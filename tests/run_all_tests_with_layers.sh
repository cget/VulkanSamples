#!/bin/bash
#
# Run all the regression tests with validation layers enabled

# enable layers
export LIBVK_LAYER_NAMES=Validation
# Save any existing settings file
RESTORE_SETTINGS="false"
SETTINGS_NAME="vk_layer_settings.txt"
TMP_SETTINGS_NAME="xls.txt"
OUTPUT_LEVEL="VK_DBG_LAYER_LEVEL_ERROR"
if [ -f $SETTINGS_NAME ]; then
    echo Saving $SETTINGS_NAME to $TMP_SETTINGS_NAME
    RESTORE_SETTINGS="true"
    mv $SETTINGS_NAME $TMP_SETTINGS_NAME
else
    echo not copying layer settings
fi
# Write out settings file to run tests with
echo "MemTrackerReportLevel = $OUTPUT_LEVEL" > $SETTINGS_NAME
echo "DrawStateReportLevel = $OUTPUT_LEVEL" >> $SETTINGS_NAME
echo "ObjectTrackerReportLevel = $OUTPUT_LEVEL" >> $SETTINGS_NAME
echo "ParamCheckerReportLevel = $OUTPUT_LEVEL" >> $SETTINGS_NAME
echo "ThreadingReportLevel = $OUTPUT_LEVEL" >> $SETTINGS_NAME
echo "ShaderCheckerReportLevel = $OUTPUT_LEVEL" >> $SETTINGS_NAME

# vkbase tests that basic VK calls are working (don't return an error).
./vkbase

# vk_blit_tests test Fill/Copy Memory, Clears, CopyMemoryToImage
./vk_blit_tests

# vk_image_tests check that image can be allocated and bound.
./vk_image_tests

#vk_render_tests tests a variety of features using rendered images
# --compare-images will cause the test to check the resulting image against
# a saved "golden" image and will report an error if there is any difference
./vk_render_tests --compare-images

if [ "$RESTORE_SETTINGS" = "true" ]; then
    echo Restore $SETTINGS_NAME from $TMP_SETTINGS_NAME
    mv $TMP_SETTINGS_NAME $SETTINGS_NAME
fi

