from flask import Flask
from flask import request
import numpy as np
import pickle

app = Flask(__name__)


@app.route('/', methods=['POST'])
def index():
    try:
        # Load model from file
        model = pickle.load(open(r"C:/Users/BENAIAH/Desktop/Ben/AI/Project/model.pkl", 'rb'))
        gre = request.form.get("gre")
        toefl = request.form.get("toefl")
        cgpa = request.form.get("cgpa")
        research = request.form.get("research")
        # Shape input data
        input_data = (gre, toefl, cgpa, research)
        input_data = np.asarray(input_data)
        input_data = input_data.reshape(1, -1)
        #Make prediction
        result = model.predict(input_data)
        # If Chance of Admit greater than 60% we classify it as 1:"Admitted" or 0:"Not Admitted"
        res = ["Admitted" if each > 0.6 else "Not Admitted" for each in result]
        return {"coa": float("{0:.2f}".format(result[0])), "text": res[0]}, 200
    except Exception as e:
        print(e)
        return f"Error: {e}", 500
    
# No caching at all for API endpoints.
@app.after_request
def add_header(response):
    """
    Add headers to both force latest IE rendering engine or Chrome Frame,
    and also to cache the rendered page for 10 minutes.
    """
    response.headers['X-UA-Compatible'] = 'IE=Edge,chrome=1'
    response.headers['Cache-Control'] = 'public, max-age=0'

if __name__ == '__main__':
    app.run()
