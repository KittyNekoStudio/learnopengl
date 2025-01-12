#pragma once

typedef struct Shader {
    unsigned int ID;
} Shader;

Shader InitShader(const char* vertexPath, const char* fragmentPath);
void UseShader(Shader* shader);
void CheckCompileErrors(unsigned int shader, char type[]);