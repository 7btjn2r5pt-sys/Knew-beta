export default async function handler(req, res) {

  if (req.method !== "POST") {
    return res.status(405).json({
      error: "Method not allowed"
    });
  }

  try {

    const { message } = req.body;

    if (!message || typeof message !== "string") {
      return res.status(400).json({
        error: "Please provide a message."
      });
    }

    const response = await fetch(
      "https://api.openai.com/v1/responses",
      {
        method: "POST",

        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${process.env.OPENAI_API_KEY}`
        },

        body: JSON.stringify({
          model: "gpt-5.6",

          input: [
            {
              role: "system",
              content:
                "You are KNEW Beta Core, an intelligent AI assistant. Give clear, useful and accurate answers."
            },

            {
              role: "user",
              content: message
            }
          ]
        })
      }
    );

    const data = await response.json();

    if (!response.ok) {
      return res.status(response.status).json({
        error: data.error?.message || "AI request failed.",
        status: response.status,
        details: data
      });
    }

    const answer =
      data.output_text ||
      "KNEW could not generate a response.";

    return res.status(200).json({
      answer
    });

  } catch (error) {

    return res.status(500).json({
      error: error.message || String(error),
      name: error.name || "UnknownError",
      stack: error.stack || "No stack available"
    });

  }

}
