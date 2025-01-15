#pragma once
#include <stdbool.h>

typedef struct Shader {
    unsigned int ID;
} Shader;

Shader InitShader(const char* vertexPath, const char* fragmentPath);
void UseShader(Shader* shader);
void CheckCompileErrors(unsigned int shader, char type[]);

void SetUniformBool(Shader* shader, char* name, bool value);
void SetUniformFloat(Shader* shader, char* name, float value);
void SetUniformInt(Shader* shader, char* name, int value);