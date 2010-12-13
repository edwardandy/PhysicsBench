TEST_TARGET=Tests
SDK=macosx10.6
COMMAND=xcodebuild

default:
# Set default make action here

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*

test:
	GHUNIT_AUTORUN=1 GHUNIT_AUTOEXIT=1 $(COMMAND) -v -target $(TEST_TARGET) -configuration Debug -sdk $(SDK) build
