# tiny-liquidsoap

A very minimal Liquidsoap image for Docker with audio processing plugins.
The image is optimized for size.
Video processing capabilities, notably `ffmpeg` are not included.

## Usage

You probably need an [Icecast2](https://icecast.org) streaming server,
and certainly a Liquidsoap script for audio processing.
See [Quickstart](https://www.liquidsoap.info/doc-1.4.1/quick_start.html)
for examples.

The control script should be mounted into the `/music` volume of the container.
Run it like so:

    docker run --name=liquidsoap -p "1234:1234" \
        -v path/to/music/dir:/music:ro \
        dnknth/tiny-liquidsoap /music/control-script.liq

## Notes

Telnet access for remote control is available on port 1234.

If audio files are not locally mounted but fetched via HTTP,
make certain that the server sends correct MIME types.
Liquidsoap needs it to determine the appropriate audio decoder.
