#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <ctype.h>
#include "./structs.h"

int add_last(void **arr, int *len, data_structure *data)
{
    if (*len == 0) {
        *arr = malloc(data->header->len * sizeof(uint8_t));
        memcpy(*arr, data->data, data->header->len);
        *len = *len + data->header->len;
    }
    else {
        void* buf = realloc(*arr, *len + data->header->len);
        memcpy((uint8_t*)buf + *len, data->data, data->header->len);
        *arr = buf;
        *len = *len + data->header->len;
    }
    return 0;
}

int add_at(void **arr, int *len, data_structure *data, int index)
{
    void* buf = realloc(*arr, *len + data->header->len);
    *arr = buf;

    uint8_t* startPtr = *arr;
    int counter = 0, offset = 0;

    while (counter < index) {
        counter++;
        offset = offset + ((uint8_t*)*arr)[offset+1] + 2*sizeof(uint8_t);
        startPtr = (uint8_t*)*arr + offset;
    }


    int nrBytesMove = *len - offset;
    memmove((uint8_t *)startPtr + data->header->len, (uint8_t*)startPtr, nrBytesMove);
    memcpy((uint8_t*)startPtr, data->data, data->header->len);
    *len = *len + data->header->len;

    return 0;
}

void find(void *arr, int len, int index)
{
    if (index >= arr_count(arr, len) || index < 0)
        return;
    uint8_t* startPtr = arr;
    int counter = 0, offset = 0;
    while (counter < index) {
        counter++;
        offset = offset + ((uint8_t*)arr)[offset+1] + 2*sizeof(uint8_t);
    }
    startPtr = (uint8_t*)arr + offset;
    uint8_t type = ((uint8_t*)startPtr)[0] - '0';

    printf("Tipul %d\n", type);
    char* name1 = &((char*)startPtr)[2*sizeof(uint8_t)];
    printf("%s pentru ", name1);

    if (type == 1) {
        char *name2 = &((char *) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1 + 2*sizeof(uint8_t)];
        printf("%s\n", name2);

        uint8_t nr1 = ((uint8_t*) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1];
        uint8_t nr2 = ((uint8_t*) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint8_t)];
        printf("%"PRId8"\n", nr1);
        printf("%"PRId8"\n", nr2);
    }
    else if (type == 2) {
        char *name2 = &((char *) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint16_t) + sizeof(uint32_t)];
        printf("%s\n", name2);

        uint16_t nr1 = bytes_to_int16(&((uint8_t*) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1]);
        uint32_t nr2 = bytes_to_int32(&((uint8_t*) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint16_t)]);
        printf("%"PRId16"\n", nr1);
        printf("%"PRId32"\n", nr2);
    }
    else if (type == 3) {
        char *name2 = &((char *) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint32_t) + sizeof(uint32_t)];
        printf("%s\n", name2);

        uint32_t nr1 = bytes_to_int32(&((uint8_t*) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1]);
        uint32_t nr2 = bytes_to_int32(&((uint8_t*) startPtr)[2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint32_t)]);
        printf("%"PRId32"\n", nr1);
        printf("%"PRId32"\n", nr2);
    }
    printf("\n");
}

int delete_at(void **arr, int *len, int index)
{

    int counter = 0, offset = 0;
    while (counter < index) {
        counter++;
        offset += ((uint8_t*)arr)[offset+1] + 2*sizeof(uint8_t);
    }
    uint8_t* startPtr = (uint8_t *)arr + offset;


    int nrBytesRemove = startPtr[1] + 2*sizeof(uint8_t);

    if (index != arr_count(arr, *len) - 1) {
        memmove((uint8_t*)startPtr, (uint8_t*)startPtr+nrBytesRemove, *len - nrBytesRemove);
    }

    void** buf = realloc(arr, *len - nrBytesRemove);
    arr = buf;
    *len = *len - nrBytesRemove;
    return 0;
}

void print(void *arr, int len) {
    unsigned int i = 0;
    while(i < len) {
        uint8_t currentType = ((uint8_t*)arr)[i] - '0';
        uint8_t currentLen = ((uint8_t*)arr)[i+1] + 2*sizeof(uint8_t);

        printf("Tipul %d\n", currentType);

        char* name1 = &((char*)arr)[i + 2*sizeof(uint8_t)];
        printf("%s pentru ", name1);

        if (currentType == 1) {
            char *name2 = &((char *) arr)[i + 2*sizeof(uint8_t) + 2*sizeof(uint8_t) + strlen(name1) + 1];
            printf("%s\n", name2);

            uint8_t nr1 = ((uint8_t*)arr)[i + 2*sizeof(uint8_t) + strlen(name1) + 1];
            uint8_t nr2 = ((uint8_t*)arr)[i + 2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint8_t)];
            printf("%"PRId8"\n", nr1);
            printf("%"PRId8"\n", nr2);
        }
        else if (currentType == 2) {
            char *name2 = &((char *) arr)[i + 2*sizeof(uint8_t) + sizeof(uint16_t) + sizeof(uint32_t) + strlen(name1) + 1];
            printf("%s\n", name2);

            uint16_t nr1 = bytes_to_int16(&((uint8_t*)arr)[i + 2*sizeof(uint8_t) + strlen(name1) + 1]);
            uint32_t nr2 = bytes_to_int32(&((uint8_t*)arr)[i + 2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint16_t)]);
            printf("%"PRId16"\n", nr1);
            printf("%"PRId32"\n", nr2);
        }
        else if (currentType == 3) {
            char *name2 = &((char *) arr)[i + 2*sizeof(uint8_t) + sizeof(uint32_t) + sizeof(uint32_t) + strlen(name1) + 1];
            printf("%s\n", name2);

            uint32_t nr1 = bytes_to_int32(&((uint8_t*)arr)[i + 2*sizeof(uint8_t) + strlen(name1) + 1]);
            uint32_t nr2 = bytes_to_int32(&((uint8_t*)arr)[i + 2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint32_t)]);
            printf("%"PRId32"\n", nr1);
            printf("%"PRId32"\n", nr2);
        }
        printf("\n");
        i += currentLen;
    }
}

void exit_free(void **arr, int len)
{
    if (len != 0) {
        free(*arr);
    }
}



int main() {
	void *arr = NULL;
	int len = 0;

    char* commandLine = malloc(sizeof(char) * 256);
    while (strcmp(commandLine, "exit") != 0) {
        gets(commandLine);

        //gets_s(commandLine, 256);
        char *tokens[7] = {NULL};
        parseInput(commandLine, tokens);

        if (strcmp(my_strlwr(tokens[0]), "insert") == 0) {
            head* newHead = malloc(sizeof(head));
            data_structure* newStruct = malloc(sizeof(data_structure));

            unsigned int data_size = 2*sizeof(uint8_t) + strlen(tokens[2]) + strlen(tokens[5]) + 2; // in bytes
            if (strcmp(tokens[1], "1") == 0)
                data_size += 2 * sizeof(uint8_t);
            else if (strcmp(tokens[1], "2") == 0)
                data_size += sizeof(uint16_t) + sizeof(uint32_t);
            else
                data_size += 2 * sizeof(uint32_t);

            void *auxArr = malloc(data_size);
            unsigned int pos = 0;
            char *dummyPtr;

            //tip:
            char type = tokens[1][0];
            memcpy(auxArr, &type, sizeof(char));
            pos += sizeof(char);

            //len:
            uint8_t auxLen = data_size - sizeof(char) - sizeof(uint8_t);
            memcpy((uint8_t *)auxArr+pos, &auxLen, sizeof(uint8_t));
            pos += sizeof(uint8_t);

            //nume1:
            memcpy((char*)auxArr+pos, tokens[2], strlen(tokens[2])+1);
            pos += strlen(tokens[2])+1;

            if (strcmp(tokens[1], "1") == 0) {
                uint8_t auxNr = strtol(tokens[3], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint8_t));
                pos += sizeof(uint8_t);

                auxNr = strtol(tokens[4], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint8_t));
                pos += sizeof(uint8_t);
            }
            else if (strcmp(tokens[1], "2") == 0) {
                uint16_t auxNr = strtol(tokens[3], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint16_t));
                pos += sizeof(uint16_t);

                uint32_t auxNr2 = strtol(tokens[4], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr2, sizeof(uint32_t));
                pos += sizeof(uint32_t);
            }
            else {
                uint32_t auxNr = strtol(tokens[3], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint32_t));
                pos += sizeof(uint32_t);

                auxNr = strtol(tokens[4], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint32_t));
                pos += sizeof(uint32_t);
            }

            memcpy((char*)auxArr+pos, tokens[5], strlen(tokens[5])+1);

            newHead->type = tokens[1][0];
            newHead->len = data_size;
            newStruct->header = newHead;
            newStruct->data = malloc(data_size);
            memcpy(newStruct->data, auxArr, data_size);

            add_last(&arr, &len, newStruct);

            free(newStruct->data);
            free(newStruct);
            free(newHead);
            free(auxArr);
        }
        else if (strcmp(my_strlwr(tokens[0]), "insert_at") == 0) {
            head* newHead = malloc(sizeof(head));
            data_structure* newStruct = malloc(sizeof(data_structure));

            //0=cmd, 1=index, 2=type, 3=name1, 4=val1, 5=val2, 6=name2

            unsigned int data_size = 2*sizeof(uint8_t) + strlen(tokens[3]) + strlen(tokens[6]) + 2; // in bytes
            if (strcmp(tokens[2], "1") == 0)
                data_size += 2 * sizeof(uint8_t);
            else if (strcmp(tokens[2], "2") == 0)
                data_size += sizeof(uint16_t) + sizeof(uint32_t);
            else
                data_size += 2 * sizeof(uint32_t);

            void *auxArr = malloc(data_size);
            unsigned int pos = 0;
            char *dummyPtr;

            //tip:
            char type = tokens[2][0];
            memcpy(auxArr, &type, sizeof(char));
            pos += sizeof(char);

            //len:
            uint8_t auxLen = data_size - sizeof(char) - sizeof(uint8_t);
            memcpy((uint8_t *)auxArr+pos, &auxLen, sizeof(uint8_t));
            pos += sizeof(uint8_t);

            //nume1:
            memcpy((char*)auxArr+pos, tokens[3], strlen(tokens[3])+1);
            pos += strlen(tokens[3])+1;

            if (strcmp(tokens[2], "1") == 0) {
                uint8_t auxNr = strtol(tokens[4], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint8_t));
                pos += sizeof(uint8_t);

                auxNr = strtol(tokens[5], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint8_t));
                pos += sizeof(uint8_t);
            }
            else if (strcmp(tokens[2], "2") == 0) {
                uint16_t auxNr = strtol(tokens[4], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint16_t));
                pos += sizeof(uint16_t);

                uint32_t auxNr2 = strtol(tokens[5], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr2, sizeof(uint32_t));
                pos += sizeof(uint32_t);
            }
            else {
                uint32_t auxNr = strtol(tokens[4], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint32_t));
                pos += sizeof(uint32_t);

                auxNr = strtol(tokens[5], &dummyPtr, 10);
                memcpy((uint8_t*)auxArr+pos, &auxNr, sizeof(uint32_t));
                pos += sizeof(uint32_t);
            }

            memcpy((char*)auxArr+pos, tokens[6], strlen(tokens[6])+1);

            newHead->type = tokens[2][0];
            newHead->len = data_size;
            newStruct->header = newHead;
            newStruct->data = malloc(data_size);
            memcpy(newStruct->data, auxArr, data_size);

            int index = strtol(tokens[1], &dummyPtr, 10);

            if (index >= 0 && index < arr_count(arr, len) && len != 0) {
                add_at(&arr, &len, newStruct, index);
            }
            else if (index >= arr_count(arr, len) || len == 0) {
                add_last(&arr, &len, newStruct);
            }

            free(newStruct->data);
            free(newStruct);
            free(newHead);
            free(auxArr);
        }
        else if (strcmp(my_strlwr(tokens[0]), "print") == 0) {
            print(arr, len);
        }
        else if (strcmp(my_strlwr(tokens[0]), "find") == 0) {
            char* dummyPtr = NULL;
            int index = strtol(tokens[1], &dummyPtr, 10);
            find(arr, len, index);
        }
        else if (strcmp(my_strlwr(tokens[0]), "delete_at") == 0) {
            char* dummyPtr = NULL;
            int index = strtol(tokens[1], &dummyPtr, 10);

            if (index >= 0 && index < arr_count(arr, len) && len != 0) {
                delete_at(arr, &len, index);
            }
            else if (index >= 0 && index >= arr_count(arr, len) && len != 0) {
                index = arr_count(arr, len) - 1;
                delete_at(arr, &len, index);
            }
        }
    }

    exit_free(&arr, len);
    free(commandLine);
	return 0;
}
