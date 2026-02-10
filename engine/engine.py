from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/run', methods=['GET', 'POST'])
def run_engine():
    result = {
        "status": "success",
        "hi": "hello"
    }
    return jsonify(result)