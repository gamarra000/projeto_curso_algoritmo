# app.py
from flask import Flask, request, jsonify, send_file
from TTS.api import TTS
import uuid
import os

# Diretório onde os arquivos .wav serão salvos
AUDIO_DIR = "audios"
os.makedirs(AUDIO_DIR, exist_ok=True)

app = Flask(__name__)

# Inicializa o modelo TTS
tts = TTS(model_name="tts_models/en/ljspeech/tacotron2-DDC", progress_bar=False, gpu=False)

@app.route("/speak", methods=["POST"])
def speak():
    data = request.json
    text = data.get("text")
    if not text:
        return jsonify({"error": "Missing 'text'"}), 400

    filename = f"{uuid.uuid4().hex}.wav"
    output_path = os.path.join(AUDIO_DIR, filename)
    tts.tts_to_file(text=text, file_path=output_path)
    return jsonify({"message": "Success", "audio_file": filename})

@app.route("/audio/<filename>", methods=["GET"])
def get_audio(filename):
    file_path = os.path.join(AUDIO_DIR, filename)
    if not os.path.exists(file_path):
        return jsonify({"error": "File not found"}), 404
    return send_file(file_path, mimetype="audio/wav")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)