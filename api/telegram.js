export default async function handler(req, res) {
  if (req.method === 'POST') {
    try {
      const update = req.body;

      if (update && update.message && update.message.text) {
        const chatId = update.message.chat.id;
        const texto = update.message.text.trim();

        if (texto.startsWith('/start') || texto) {
          const TELEGRAM_BOT_TOKEN = "8880858238:AAHIRsSFzP6If8XAnjBzxrSpqGvxHHw3o4g";
          const mensajeRespuesta = `¡Bienvenido al sistema del C.E. Guaicaipuro! Tu código de registro (Chat ID) es: ${chatId}. Por favor entrégalo en la institución.`;

          await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              chat_id: chatId,
              text: mensajeRespuesta,
              parse_mode: 'Markdown'
            })
          });
        }
      }
      return res.status(200).json({ status: "ok" });
    } catch (error) {
      console.error("Error en webhook de Telegram:", error);
      return res.status(500).json({ error: error.message });
    }
  }

  return res.status(200).json({ status: "El bot está activo y funcionando" });
}
