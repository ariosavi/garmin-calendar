# Calendar for Garmin devices

A simple Gregorian calendar widget for Garmin devices (watch, gps, and map, etc.)

## Features

- Display the current Gregorian date
- Navigate through the calendar using swipe or up/down buttons
- Configure style settings through Garmin Connect IQ's Settings Page

## Manual Deployment

Copy the `.prg` file to the `/GARMIN/APPS/` directory on your Garmin device.

## Script: create_drawables.sh

The `create_drawables.sh` script is used to create directories for different icon sizes and resize the launcher icon accordingly. It uses ImageMagick to resize the images.

To run the script, use the following command:

```sh
./resources/create_drawables.sh
```

## Configuration (Settings Page)

The application supports user settings through Garmin Connect IQ's Settings Page.

### Available Settings

- Week Start Day: `Sunday / Monday / Saturday` (default: `Sunday`)
- Date Separator: `Slash / Dash / Dot / Space` (default: `Slash`)

## Related document

- [Devices Reference](https://developer.garmin.com/connect-iq/reference-guides/devices-reference/#devicereference)
- [Compatible Devices](https://developer.garmin.com/connect-iq/compatible-devices/)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.