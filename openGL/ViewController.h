//
//  ViewController.h
//  openGL
//
//  Created by Abhishek Garg on 14/03/16.
//  Copyright © 2016 Abhishek Garg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ShaderHelper.h"
#import "Planet1.h"

@interface ViewController : GLKViewController
{
    EAGLContext *context;
    ShaderHelper *shaderHelper;
    int programObject;

    int positionIndex;
    int colorIndex;
    int modelMatrixIndex;
    int projectionMatrixIndex;
    int viewMatrixIndex;
    float xPosOffset,yPosOffset,angle,scale,zPos,angle2;
    GLKMatrix4 modelMatrix;
    GLKMatrix4 projectionMatrix;
    GLKMatrix4 viewMatrix;
    
    int clipPlaneIndex;
    
    int textureCoordinateIndex;
    int activeTextureIndex;
    GLuint textureID;
    
    unsigned int triangleVBO;
    
    Planet *sun;
    Planet *moon;
    Planet *earth;
    
    GLKTextureInfo *backgroundTexture;
    
}



@end

