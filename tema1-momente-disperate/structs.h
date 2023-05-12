typedef struct head {
	unsigned char type;
	unsigned int len;
} head;

typedef struct data_structure {
	head *header;
	void *data;
} data_structure;

void print_bytes(void* arr, unsigned int nbytes) {
    for (int i=0; i<nbytes; i++)
        printf("%d ", ((char*)arr)[i]);
    printf("\n");
}

void parseInput(char commandLine[], char *tokens[]) {
    int count = 0;

    char *p = strtok(commandLine, " ");
    while(p && count < 7) {
        tokens[count] = p;
        p = strtok(NULL, " ");
        count++;
    }
}

uint16_t bytes_to_int16(uint8_t* arr) {
    uint16_t val;
    memcpy(&val, arr, sizeof(uint16_t));
    return val;
}

uint32_t bytes_to_int32(uint8_t* arr) {
    uint32_t val;
    memcpy(&val, arr, sizeof(uint32_t));
    return val;
}

uint8_t arr_count(void* arr, int len) {
    uint8_t counter = 0;
    unsigned int i = 0;
    while(i < len) {
        uint8_t currentLen = ((uint8_t*)arr)[i+1] + 2*sizeof(uint8_t);
        i += currentLen;
        counter++;
    }
    return counter;
}



char* my_strlwr(char *str)
{
    unsigned char *p = (unsigned char *)str;

    while (*p) {
        *p = tolower((unsigned char)*p);
        p++;
    }

    return str;
}