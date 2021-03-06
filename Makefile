# The ARM toolchain prefix (32 bit = arm-...-eabi, 64 bit = aarch64-...-gnueabi)
# TOOLCHAIN = arm-none-eabi
# TOOLCHAIN = /usr/local/gcc-arm-none-eabi-6-2017-q2-update/bin/arm-none-eabi
# TOOLCHAIN = /root/x-tools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf
TOOLCHAIN = /root/x-tools/aarch64-rpi3-linux-gnueabi/bin/aarch64-rpi3-linux-gnueabi

AARCH = 
CCFLAGS = -nostartfiles -ffreestanding -mcpu=cortex-a53 -ggdb
# CCFLAGS = -nostartfiles -ffreestanding -mfpu=vfp -mcpu=cortex-a53 -ggdb

# AARCH = -march=armv6 
# CCFLAGS = -O2 -Wall -nostartfiles -ffreestanding $(AARCH)

TARGET = kernel8
BUILD = build
SOURCE = src

COPY = /Volumes/boot

SOBJ = bootcode.o
UOBJ = 

all: $(BUILD)/$(TARGET).img $(BUILD)/$(TARGET).list

# ELF
$(BUILD)/$(TARGET).elf: $(addprefix $(BUILD)/, $(SOBJ)) $(addprefix $(BUILD)/, $(UOBJ))
	$(TOOLCHAIN)-gcc $(CCFLAGS) -T $(SOURCE)/linker.ld $^ -o $(BUILD)/$(TARGET).elf

# ELF to LIST
$(BUILD)/$(TARGET).list: $(BUILD)/$(TARGET).elf
	$(TOOLCHAIN)-objdump -D $(BUILD)/$(TARGET).elf > $(BUILD)/$(TARGET).list

# ELF to IMG
$(BUILD)/$(TARGET).img: $(BUILD)/$(TARGET).elf
	$(TOOLCHAIN)-objcopy -O binary $(BUILD)/$(TARGET).elf $(BUILD)/$(TARGET).img

$(addprefix $(BUILD)/, $(SOBJ)): $(BUILD)/%.o: $(SOURCE)/asm/%.s $(addprefix $(SOURCE)/c/, $(HOBJ))
	$(TOOLCHAIN)-as $(SOURCE)/asm/$(basename $(@F)).s -o $@

$(addprefix $(BUILD)/, $(UOBJ)): $(BUILD)/%.o: $(SOURCE)/c/%.c $(addprefix $(SOURCE)/c/, $(HOBJ))
	$(TOOLCHAIN)-gcc $(CCFLAGS) -c $(SOURCE)/c/$(basename $(@F)).c -o $@

copy: all
	cp $(BUILD)/$(TARGET).img $(COPY)/$(TARGET).img

clean:
	rm -f $(BUILD)/*

# Cross compile the binary using a container with the toolchain already built, when running in this environment, $(TOOLCHAIN) must point to the path within the cointainer
DOCKER_IMAGE = toolchain
DOCKER_BUILD = /root/build
start-toolchain:
	docker run --rm -it -v $(CURDIR):$(DOCKER_BUILD) -w $(DOCKER_BUILD) $(DOCKER_IMAGE)
