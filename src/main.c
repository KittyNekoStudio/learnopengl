#include <stdio.h>

#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include "shader.h"

#define true 1
#define false 0

static void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
	glViewport(0, 0, width, height);
}

static void processInput(GLFWwindow* window) {
	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
		glfwSetWindowShouldClose(window, true);
	}
}

static void setColorBlueOrRedOrGreen(GLFWwindow* window) {
	if (glfwGetKey(window, GLFW_KEY_R) == GLFW_PRESS) {
		glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
	} else if (glfwGetKey(window, GLFW_KEY_B) == GLFW_PRESS) {
		glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
	} else if (glfwGetKey(window, GLFW_KEY_G) == GLFW_PRESS) {
		glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
	} else if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS) {
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	} else if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS) {
		glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	} else {
		glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
	}
}

int main() {

	glfwInit();
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

	GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
	if (window == NULL) {
		printf("Failed to create OpengGL window.\n");
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(window);

	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
		printf("Faild to initalize GLAD.\n");
		return -1;
	}

	Shader myShaders = InitShader("../shaders/vertex.vs", "../shaders/fragment.fs");

	if (myShaders.ID == -1) {
		return -1;
	}

	float vertices[18] = {
		// Positions	// Colors
		0.5, -0.5, 1.0, 1.0f, 0.0f, 0.0f, // Bottom right
	   -0.5, -0.5, 0.0, 0.0f, 1.0f, 0.0f, // Bottom left
		0.0,  0.5, 0.0,	0.0f, 0.0f, 1.0f, // Top
	};

	unsigned int VAO;
	glGenVertexArrays(1, &VAO);

	unsigned int VBO;
	glGenBuffers(1, &VBO);

	glBindVertexArray(VAO);
	
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0);

	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
	glEnableVertexAttribArray(1);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	glViewport(0, 0, 800, 600);
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

	//glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	while (!glfwWindowShouldClose(window)) {
		processInput(window);

		setColorBlueOrRedOrGreen(window);
		glClear(GL_COLOR_BUFFER_BIT);

		UseShader(&myShaders);	
		glBindVertexArray(VAO);
		glDrawArrays(GL_TRIANGLES, 0, 3);

		glfwSwapBuffers(window);
		glfwPollEvents();
	}

	glDeleteVertexArrays(1, &VAO);
	glDeleteBuffers(1, &VBO);

	glfwTerminate();
	return 0;
}
