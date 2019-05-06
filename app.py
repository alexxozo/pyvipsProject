from flask import Flask, render_template
import os, pyvips
import ffmpeg

app = Flask(__name__, static_folder="static")

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

# Compatabile with all browsers
image1 = pyvips.Image.thumbnail(APP_ROOT + "/static/image1.jpg", 150, height=150, size="VIPS_SIZE_FORCE")
image5 = pyvips.Image.thumbnail(APP_ROOT + "/static/image5.png", 150, height=150, size="VIPS_SIZE_FORCE")

# Compatible with Chrome webp, webm
image2 = pyvips.Image.thumbnail(APP_ROOT + "/static/image2.svg", 150, height=150, size="VIPS_SIZE_FORCE")
ffmpeg.input(APP_ROOT + '/static/image3.gif').output(APP_ROOT + '/static/image3-modified.webm').run()
image4 = pyvips.Image.thumbnail(APP_ROOT + "/static/image4.png", 150, height=150, size="VIPS_SIZE_FORCE")

image1.write_to_file(APP_ROOT + '/static/image1-modified.jpg')
image5.write_to_file(APP_ROOT + '/static/image5-modified.png')

image2.write_to_file(APP_ROOT + '/static/image2-modified.webp')
image4.write_to_file(APP_ROOT + '/static/image4-modified.webp')

previous_images = ["static/image1.jpg",  "static/image2.svg", "static/image3.gif", "static/image4.png", "static/image5.png"]
processed_images = ["static/image1-modified.jpg",  "static/image2-modified.webp", "static/image4-modified.webp", "static/image5-modified.png"]

@app.route('/')
def index():
	return render_template('index.html', results=processed_images)

if __name__ == "__main__":
    app.run(host="0.0.0.0")