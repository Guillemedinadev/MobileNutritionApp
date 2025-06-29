const functions = require("firebase-functions");
const admin = require("firebase-admin");
const fetch = require("node-fetch");

admin.initializeApp();
const db = admin.firestore();

const OPENAI_API_KEY = "sk-proj-j6hvjymV2Ht6THnGF3ys" +
  "QIzy3aWTTtaGAQt6EOq0xmiqq7KTSdhYIzJXaulcWX0G1dPe3-_" +
  "KgST3BlbkFJ5jFGEBT7duD4SvXTnr-95VivNsF8oDxLD8Br" +
  "UMIzDrW9BOsGKbbQLorcxhuPbXoAIAIwAFv5wA";

// llamada a OpenAI
async function pedirRespuestaOpenAI(messages) {
  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${OPENAI_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o",
      messages,
    }),
  });

  const data = await response.json();
  return data.choices[0].message.content.trim();
}
function formatoFecha(fecha) {
  const d = new Date(fecha);
  return `${d.getFullYear()}-${(d.getMonth()+1).toString().padStart(2, "0")}-${d.getDate().toString().padStart(2, "0")}`;
}

async function actualizarTotales(userId, fechaId) {
  const historialRef = db.collection("usuarios").doc(userId).collection("historial").doc(fechaId);

  const capturadosSnapshot = await historialRef.collection("capturados").get();

  let calorias = 0;
  let proteinas = 0;
  let grasas = 0;
  let grasasSaturadas = 0;
  let hidratosDeCarbono = 0;
  let azucares = 0;
  let fibra = 0;
  let sal = 0;

  capturadosSnapshot.forEach((doc) => {
    const data = doc.data();
    calorias += data.calorias || 0;
    proteinas += data.proteinas || 0;
    grasas += data.grasas || 0;
    grasasSaturadas += data.grasasSaturadas || 0;
    hidratosDeCarbono += data.hidratosDeCarbono || 0;
    azucares += data.azucares || 0;
    fibra += data.fibra || 0;
    sal += data.sal || 0;
  });

await historialRef.set({
    fecha: fechaId,
    totales: {
      calorias,
      proteinas,
      grasas,
      grasasSaturadas,
      hidratosDeCarbono,
      azucares,
      fibra,
      sal,
    },
  }, { merge: true });
}

// función principal
exports.procesarComida = functions.https.onRequest(async (req, res) => {
  const { userId, imageUrl, tipo, fecha} = req.body;

  if (!userId || !imageUrl || !tipo) {
    return res.status(400).send("Faltan campos obligatorios.");
  }

  const fechaId = formatoFecha(fecha);

  let systemMessageContent = "";
  if (tipo === "etiqueta") {
    systemMessageContent = `
Eres un experto en nutrición. Analiza la imagen de una etiqueta de información nutricional (formato de producto industrial).

Devuelve solo un JSON con las siguientes claves exactas (minúsculas, con guiones bajos) y sus valores por 100g o por ración, si se indica:

{
  "nombre": "string con el nombre del alimento",
  "calorias": número,
  "grasas": número,
  "grasasSaturadas": número,
  "hidratosDeCarbono": número,
  "azucares": número,
  "proteinas": número,
  "sal": número,
  "fibra": número
}

Si algún dato no aparece, indícalo como null. No añadas texto extra ni explicaciones. Solo JSON.
    `;
  } else if (tipo === "comida") {
    systemMessageContent = `
Eres un nutricionista experto. Estás viendo una imagen de un plato de comida.

Estima los valores nutricionales aproximados del plato. Devuelve solo un JSON con las siguientes claves exactas y sus valores estimados por ración:

{
  "nombre": "nombre estimado del plato",
  "calorias": número,
  "grasas": número,
  "grasasSaturadas": número,
  "hidratosDeCarbono": número,
  "azucares": número,
  "proteinas": número,
  "sal": número,
  "fibra": número
}

Si no puedes estimar algún valor, pon null. No añadas ningún texto ni explicaciones. Solo JSON.
    `;
  } else {
    return res.status(400).send("Tipo no soportado.");
  }

  function parseNutrientes(data) {
    return {
      nombre: data.nombre || null,
      calorias: typeof data.calorias === "number" ? data.calorias : null,
      grasas: typeof data.grasas === "number" ? data.grasas : null,
      grasasSaturadas: typeof data.grasasSaturadas === "number" ? data.grasasSaturadas : null,
      hidratosDeCarbono: typeof data.hidratosDeCarbono === "number" ? data.hidratosDeCarbono : null,
      azucares: typeof data.azucares === "number" ? data.azucares : null,
      proteinas: typeof data.proteinas === "number" ? data.proteinas : null,
      sal: typeof data.sal === "number" ? data.sal : null,
      fibra: typeof data.fibra === "number" ? data.fibra : null,
      fecha: formatoFecha(new Date()),
    };
  }

  try {
    const messages = [
      { role: "system", content: systemMessageContent },
      {
        role: "user",
        content: [
          { type: "text", text: "Extrae los valores nutricionales y devuelve el JSON." },
          { type: "image_url", image_url: { url: imageUrl } },
        ],
      },
    ];

    const content = await pedirRespuestaOpenAI(messages);

    let cleanContent = content;
    if (cleanContent.startsWith("```json")) {
      cleanContent = cleanContent.slice(7).trim();
    } else if (cleanContent.startsWith("```")) {
      cleanContent = cleanContent.slice(3).trim();
    }
    if (cleanContent.endsWith("```")) {
      cleanContent = cleanContent.slice(0, -3).trim();
    }

    const jsonData = JSON.parse(cleanContent);
    const resultadoNormalizado = parseNutrientes(jsonData);

    const historialRef = db
    .collection("usuarios")
    .doc(userId)
    .collection("historial")
    .doc(fechaId);

    await historialRef.set({}, { merge: true });

    const nuevoAlimento = {
      id: db.collection("temp").doc().id,
      ...resultadoNormalizado,
      tipoComida: tipo,
      cantidad: 100,
    };

    await historialRef.collection("capturados").doc(nuevoAlimento.id).set(nuevoAlimento);

    await actualizarTotales(userId, fechaId);

    res.status(200).json({ success: true, data: resultadoNormalizado });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Error al procesar la imagen.");
  }
});
