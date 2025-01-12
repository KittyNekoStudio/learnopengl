#include <stdio.h>
#include <stdlib.h>
#include <glad/glad.h>

#include "shader.h"

char* FileToString(FILE* file) {
    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    rewind(file);

    char* buffer = malloc(fileSize + 1);
    if (buffer == NULL) {
        printf("ERROR ALLOCATING MEMORY TO FILE BUFFER\n");
        return NULL;
    }

    size_t bytesRead = fread(buffer, 1, fileSize, file);
    if (bytesRead != fileSize) {
        printf("BYTESREAD != FILE SIZE\n");
        free(buffer);
        return NULL;
    }

    buffer[bytesRead] = '\0';

    return buffer;
}

Shader InitShader(const char* vertexPath, const char* fragmentPath) {
    FILE* vertexShaderFile = fopen(vertexPath, "r");

    if (vertexShaderFile == NULL) {
        printf("FAILED TO OPEN VERTEX SHADER\n");
        Shader nullShader;
        nullShader.ID = -1;
        return nullShader;
    }

    FILE* fragmentShaderFile = fopen(fragmentPath, "r");

    if (fragmentShaderFile == NULL) {
        printf("FAILED TO OPEN FRAGMENT SHADER\n");
        Shader nullShader;
        nullShader.ID = -1;
        return nullShader;
    }

    const char* vertexCode = FileToString(vertexShaderFile);

    if (vertexCode == NULL) {
        fclose(vertexShaderFile);
        Shader nullShader;
        nullShader.ID = -1;
        return nullShader;
    }    
    
    const char* fragmentCode = FileToString(fragmentShaderFile);

    if (fragmentCode == NULL) {
        fclose(fragmentShaderFile);
        Shader nullShader;
        nullShader.ID = -1;
        return nullShader;
    }

    unsigned int vertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex, 1, &vertexCode, NULL);
    glCompileShader(vertex);
    CheckCompileErrors(vertex, "VERTEX");

    unsigned int fragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment, 1, &fragmentCode, NULL);
    glCompileShader(fragment);
    CheckCompileErrors(fragment, "FRAGMENT");

    Shader shader;
    shader.ID = glCreateProgram();
    glAttachShader(shader.ID, vertex);
    glAttachShader(shader.ID, fragment);
    glLinkProgram(shader.ID);
    CheckCompileErrors(shader.ID, "PROGRAM");

    glDeleteShader(vertex);
    glDeleteShader(fragment);

    return shader;
 }

void UseShader(Shader* shader) {
    glUseProgram(shader->ID);
}

void CheckCompileErrors(unsigned int shader, char type[]) {
    int success;
    char infoLog[1024];
    
    if (type != "PROGRAM") {
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(shader, 1024, NULL, infoLog);
            printf("ERROR::SHADER COMPILATION ERROR of type: %s\n%s\n", type, infoLog);
        }
    }
    else {
        glGetProgramiv(shader, GL_LINK_STATUS, &success);
        if (!success) {
        glGetShaderInfoLog(shader, 1024, NULL, infoLog);
        printf("ERROR::SHADER LINKING ERROR of type: %s\n%s\n", type, infoLog);
       }
    }
}
