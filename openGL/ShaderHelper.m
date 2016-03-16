//
//  ShaderHelper.m
//  openGL
//
//  Created by Abhishek Garg on 14/03/16.
//  Copyright © 2016 Abhishek Garg. All rights reserved.
//

#import "ShaderHelper.h"
#import <OPENGLES/ES2/gl.h>

const char* V_SRC = ""
                    "attribute vec4 a_Position;               \n"
                    "attribute vec4 a_Color;                  \n"
                    "attribute vec2 a_TextureCoordinate;      \n"
                    "uniform mat4 u_ModelMatrix;              \n"
                    "uniform mat4 u_ProjectionMatrix;         \n"
                    "uniform mat4 u_ViewMatrix;               \n"
                    "varying vec4 v_Color;                    \n"
                    "varying vec2 v_TextureCoordinate;        \n"
                    "uniform vec4 u_clipPlane;                \n"
                    "varying float v_Distance;                \n"
                    "void main() {                            \n"
                    "   gl_Position = u_ProjectionMatrix * u_ModelMatrix * a_Position;           \n"
                    "   v_Color = a_Color;                    \n"
                    "   v_TextureCoordinate = a_TextureCoordinate; \n"
                    "   v_Distance = dot(gl_Position.xyz,u_clipPlane.xyz) + u_clipPlane.w;"
                    "}";
const char* F_SRC = ""
                    "precision highp float;                    \n"
                    "varying vec4 v_Color;                     \n"
                    "varying vec2 v_TextureCoordinate;         \n"
                    "uniform sampler2D activeTexture;          \n"
                    "varying float v_Distance;                 \n"
                    "void main() {                             \n"
                    "   if(v_Distance < 0.0){                  \n"
                    "       discard;                           \n"
                    "   }                                      \n"
                    "vec4 textureColor = texture2D(activeTexture,v_TextureCoordinate);\n"
                    "   gl_FragColor = textureColor;                \n"
                    "}";


@interface ShaderHelper()
-(int) createShaderOfType:(GLenum)type WithSrc:(const char*)src;
@end

@implementation ShaderHelper

-(int) createShaderOfType:(GLenum)type WithSrc:(const char *)src
{
    //create shader object
    int shaderObj = glCreateShader(type);
    if(shaderObj < 0)
    {
        NSLog(@"Unable to create shader Object of type %d",type);
        return -1;
    }
    
    //add source code to shader object
    glShaderSource(shaderObj, 1, &src, 0);
    
    //compile shader
    glCompileShader(shaderObj);
    
    //get the shader compilation status
    GLint success;
    glGetShaderiv(shaderObj, GL_COMPILE_STATUS, &success);
    if(success == GL_TRUE)
    {
        NSLog(@"Shader Compiled successfully");
        return shaderObj;
    }
    else
    {
        GLint length;
        glGetShaderiv(shaderObj, GL_INFO_LOG_LENGTH, &length);
        
        char* info = (char *)malloc(length);
        GLsizei l;
        glGetShaderInfoLog(shaderObj, length, &l, info);
        printf("Compiler Error %s",info);
        return -1;
        
    }
    return -1;
    
}
-(int) createProgramObject
{
    int vertShaderObj = [self createShaderOfType:GL_VERTEX_SHADER WithSrc:V_SRC];
    int fragShaderObj = [self createShaderOfType:GL_FRAGMENT_SHADER WithSrc:F_SRC];
    
    if(vertShaderObj < 0 || fragShaderObj < 0 )
    {
        return -1;
        
    }
    
    //create a program object
    int programObject = glCreateProgram();
    
    //attach vertex shader object and fragment shader object to program object
    glAttachShader(programObject, vertShaderObj);
    glAttachShader(programObject, fragShaderObj);
    
    //link shaders
    glLinkProgram(programObject);
    
    //Check if linking is successful
    GLint success;
    glGetProgramiv(programObject, GL_LINK_STATUS, &success);
    if(success == GL_TRUE)
    {
        NSLog(@"Shader Linked successfully");
        return programObject;
    }
    else
    {
        GLint length;
        glGetShaderiv(programObject, GL_INFO_LOG_LENGTH, &length);
        
        char* info = (char *)malloc(length);
        GLsizei l;
        glGetShaderInfoLog(programObject, length, &l, info);
        printf("Shader Linking Failed %s",info);
        return -1;
        
    }

    return -1;
    
    
}
@end
