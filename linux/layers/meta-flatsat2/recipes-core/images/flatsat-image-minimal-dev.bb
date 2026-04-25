SUMMARY = "Minimal development FlatSat2 image"

require flatsat-image-minimal.bb

IMAGE_FEATURES += " \
                  debug-tweaks \
                  tools-debug \
                  serial-autologin-root \
                  empty-root-password \
                  "
