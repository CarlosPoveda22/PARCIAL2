from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:123456@localhost:3308/sistema_legal'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Expediente(db.Model):
    __tablename__ = 'expedientes'
    id = db.Column(db.Integer, primary_key=True)
    numero_caso = db.Column(db.String(20), unique=True, nullable=False)
    id_tipo_caso = db.Column(db.Integer)
    id_aseguradora = db.Column(db.Integer)
    id_abogado = db.Column(db.Integer)
    estado = db.Column(db.String(20))

@app.route('/expedientes', methods=['GET'])
def get_expedientes():
    items = Expediente.query.all()
    results = [
        {"id": i.id, "numero": i.numero_caso, "estado": i.estado} for i in items
    ]
    return jsonify(results), 200

@app.route('/expedientes', methods=['POST'])
def create_expediente():
    data = request.json
    try:
        nuevo = Expediente(
            numero_caso=data['numero_caso'],
            id_tipo_caso=data['id_tipo_caso'],
            id_aseguradora=data['id_aseguradora'],
            id_abogado=data['id_abogado'],
            estado='Abierto'
        )
        db.session.add(nuevo)
        db.session.commit()
        return jsonify({"message": "Expediente creado"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(port=5000, debug=True)