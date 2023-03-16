from flask import Flask, request, Response, jsonify, render_template
from flask_api import status


app = Flask(__name__)

artists = list()

@app.get("/")
def index():
  return render_template("index.html")

@app.get("/ping/")
def ping():
  return "pong"

@app.get("/artists/")
def get_artists():
  data = [{"id": index, "artist" : artists[index]} for index in range(len(artists)) if artists[index] is not None]
  return jsonify(data)

@app.post("/artists/")
def post_artists():
  data = request.json
  if "artist" not in data:
    return jsonify({"error": "Missing \"artist\" in json"}), status.HTTP_400_BAD_REQUEST

  artist = data["artist"].strip()
  if artist not in artists:
    artists.append(artist)

  artist_id = artists.index(artist)
  data = {"id": artist_id, "artist": artists[artist_id]}
  return jsonify(data), status.HTTP_201_CREATED

@app.get("/artists/<int:artist_id>/")
def get_artist(artist_id):
  if artist_id not in range(len(artists)) or artists[artist_id] is None:
    return jsonify({"error": f"No artist with id={artist_id} exists"}), status.HTTP_404_NOT_FOUND

  data = {"id": artist_id, "artist": artists[artist_id]}
  return jsonify(data)

@app.post("/artists/<int:artist_id>/")
def post_artist(artist_id):
  if artist_id not in range(len(artists)):
    return jsonify({"error": f"No artist with id={artist_id} exists"}), status.HTTP_404_NOT_FOUND

  data = request.json
  if "artist" not in data:
    return jsonify({"error": "Missing \"artist\" in json"}), status.HTTP_400_BAD_REQUEST

  artists[artist_id] = data["artist"].strip()

  data = {"id": artist_id, "artist": artists[artist_id]}
  return jsonify(data)

@app.delete("/artists/<int:artist_id>/")
def delete_artist(artist_id):
  if artist_id not in range(len(artists)):
    return jsonify({"error": "No artist with id={artist_id} exists"}), status.HTTP_400_BAD_REQUEST

  artists[artist_id] = None
  return Response("", status.HTTP_204_NO_CONTENT)


if __name__ == "__main__":
  app.run(host="0.0.0.0", port=80)

