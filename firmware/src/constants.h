#define WEIGHT_DEPTH 8192
#define CHANNELS 16
#define TIME 50
#define INPUT_CHANNELS 32
#define NEURON_1 64
#define NEURON_2 128
#define NEURON_3 64
#define NEURON_4 12

#define WEIGHT_1_ADDR 1048576
#define WEIGHT_2_ADDR WEIGHT_1_ADDR+WEIGHT_DEPTH
#define WEIGHT_3_ADDR WEIGHT_2_ADDR+WEIGHT_DEPTH
#define WEIGHT_4_ADDR WEIGHT_3_ADDR+WEIGHT_DEPTH
#define SAMPLE_ADDR   WEIGHT_4_ADDR+WEIGHT_DEPTH
