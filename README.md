# tiny-liquidsoap

A very minimal Liquidsoap image for Docker with these audio processing plugins:

- faad
- flac
- lame
- mad
- ogg
- vorbis

The image is inspired by [PhasecoreX/docker-liquidsoap](https://github.com/PhasecoreX/docker-liquidsoap) and heavily optimised for size.
It uses an [Alpine Linux](https://alpinelinux.org) base image.

Video processing capabilities, notably `ffmpeg` are not included.

## Usage

You likely need an [Icecast2](https://icecast.org) streaming server,
and certainly a Liquidsoap script for audio processing.
See [Quickstart](https://www.liquidsoap.info/doc-1.4.1/quick_start.html)
for examples.

The control script should be mounted into the `/music` volume of the container.
Your music can be stored in the same volume, or on a remote web server.

Run it like so:

    docker run --name=liquidsoap -p "1234:1234" \
        -v path/to/music/dir:/music:ro \
        dnknth/tiny-liquidsoap /music/control-script.liq

## Notes

Telnet access for remote control is available on port 1234.

If audio files are not stored locally but fetched via HTTP,
make certain that the server sends correct MIME types.
Liquidsoap needs it to determine the appropriate audio decoder.
It would normally fall back to `ffmpeg` for auto-detection,
but this is not included to minimise size.
