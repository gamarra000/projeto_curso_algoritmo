from flask import Flask, request, send_file
from TTS.api import TTS
import tempfile

app = Flask(__name__)
tts = TTS(model_name="tts_models/en/ljspeech/tacotron2-DDC", progress_bar=False, gpu=False)

@app.route("/synthesize", methods=["POST"])
def synthesize():
    data = request.get_json()
    text = data.get("text", "")
    if not text:
        return {"error": "Missing 'text' field"}, 400

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
        tts.tts_to_file(text=text, file_path=f.name)
        return send_file(f.name, mimetype="audio/wav")

@app.route("/")
def health():
    return "Coqui TTS is running!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)