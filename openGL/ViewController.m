//
//  ViewController.m
//  openGL
//
//  Created by Abhishek Garg on 14/03/16.
//  Copyright © 2016 Abhishek Garg. All rights reserved.
//

#import "ViewController.h"
float triangleOne[]=
{
   -0.5,-0.5,0.0,1.0,0.0,0.0,1.0,
    0.5,-0.5,0.0,0.0,1.0,0.0,1.0,
    0.5,0.5,0.0,0.0,0.0,1.0,1.0
};
float triangleTwo[]=
{
    0.5,0.5,0.0,1.0,0.0,0.0,1.0,
    -0.5,0.5,0.0,0.0,1.0,0.0,1.0,
    -0.5,-0.5,0.0,0.0,0.0,1.0,1.0
};
float triangleStrip[]=
{
    1.0,-1.0,0.0,0.0,1.0,0.0,1.0,2,2,
    -1.0,-1.0,0.0,0.0,0.0,1.0,1.0,0,2,
    1.0,1.0,0.0,0.0,1.0,1.0,1.0,2,0,
    -1.0,1.0,0.0,0.0,1.0,0.0,1.0,0,0
};

float vertices[] =  {
                        0.5,0.0,0.0,0.0,1.0,0.0,1.0,
                        0.0,0.5,0.0,1.0,0.0,0.0,1.0,
                        -0.5,0.0,0.0,0.0,0.0,1.0,1.0
                    };
float rightTrianglesvertices[] =  {
0.5
   
};
unsigned char indices[] = {0,1,2};

//float color[]=
//{
//    1.0,0.0,0.0,1.0,
//    0.0,1.0,0.0,1.0,
//    0.0,0.0,1.0,1.0
//};

@interface ViewController ()
-(void)initGL;
-(void) initTriangleVBO;
-(int)loadTextures;
-(GLubyte *) pixelsFromImage:(NSString*)fileName;
@end

@implementation ViewController
-(int) loadTextures
{
    GLuint textureId;
    glGenTextures(1, &textureID);
    
    //bind to texture
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    //Load Image at level 0
    GLubyte* pixels = [self pixelsFromImage:@"mipmap128.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 128, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //Load Image at level 1
    pixels = [self pixelsFromImage:@"mipmap64.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA, 64, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //Load Image at level 2
    pixels = [self pixelsFromImage:@"mipmap32.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 2, GL_RGBA, 32, 32, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //Load Image at level 3
    pixels = [self pixelsFromImage:@"mipmap16.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 3, GL_RGBA, 16, 16, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //Load Image at level 4
    pixels = [self pixelsFromImage:@"mipmap8.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 4, GL_RGBA, 8, 8, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //Load Image at level 5
    pixels = [self pixelsFromImage:@"mipmap4.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 5, GL_RGBA, 4, 4, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //Load Image at level 6
    pixels = [self pixelsFromImage:@"mipmap2.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 6, GL_RGBA, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //Load Image at level 7
    pixels = [self pixelsFromImage:@"mipmap1.png"];
    
    //Upload the sprite image data to texture object
    glTexImage2D(GL_TEXTURE_2D, 7, GL_RGBA, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    free(pixels);
    
    //specify the mag and min
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST_MIPMAP_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
    
    
    
    //Unbimd from texture
    glBindTexture(GL_TEXTURE_2D, 0);
    
    return textureId;
}
-(GLubyte *) pixelsFromImage:(NSString*)imageName
{
    //generate the texture ID
    
    
    CGImageRef spriteImage = [UIImage imageNamed:imageName].CGImage;
    
    if(!spriteImage)
    {
        NSLog(@"Failed to load image %@",imageName);
        
    }
    
    //2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *)calloc(width * height *4,sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    //3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    return spriteData;
    
    
    
}
-(void) initTriangleVBO
{
    //create an identifer for the VBO
    glGenBuffers(1,&triangleVBO);
    
    //bind the VBO
    glBindBuffer(GL_ARRAY_BUFFER,triangleVBO);
    
    //copy vertex data to the VBO
    glBufferData(GL_ARRAY_BUFFER, 21 * sizeof(float), vertices, GL_STATIC_DRAW);
    
    //unbind from VBO
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //associate the context with GLKView
    GLKView *view = (GLKView*)self.view;
    view.context =context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    //make the context current or bind the context
    [EAGLContext setCurrentContext:context];
    
    shaderHelper = [[ShaderHelper alloc] init];
    programObject = [shaderHelper createProgramObject];
    
    if(programObject < 0)
    {
        NSLog(@"Shader Failed");
        return;
    }
    else
    {
        NSLog(@"Shader executable loadede successfully");
        
        //load the shader executable on GPU
        glUseProgram(programObject);
    }
    
    //get the index for attribute named "a-Position"
    positionIndex = glGetAttribLocation(programObject,"a_Position");
   
    //get the index for attribute named "a-Color"
    colorIndex = glGetAttribLocation(programObject,"a_Color");
    
    modelMatrixIndex = glGetUniformLocation(programObject, "u_ModelMatrix");
    projectionMatrixIndex = glGetUniformLocation(programObject, "u_ProjectionMatrix");
    viewMatrixIndex = glGetUniformLocation(programObject, "u_ViewMatrix");
    
    textureCoordinateIndex = glGetAttribLocation(programObject, "a_TextureCoordinate");
    activeTextureIndex = glGetUniformLocation(programObject, "activeTexture");
    
    clipPlaneIndex = glGetUniformLocation(programObject, "u_clipPlane");
    glUniform4f(clipPlaneIndex, 0.0, 0.0, 0.0, 0.0);
    
    
    sun = [[Planet alloc] init:50 slices:50 radius:1 squash:1 ProgramObject:programObject TextureFileName:@"sun.jpg"];
    earth = [[Planet alloc] init:50 slices:50 radius:1 squash:1 ProgramObject:programObject TextureFileName:@"earth.jpg"];
    moon = [[Planet alloc] init:50 slices:50 radius:1 squash:1 ProgramObject:programObject TextureFileName:@"Moon.jpg"];
    
    //Load the background texture
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stars.jpg" ofType:nil];
    backgroundTexture = [GLKTextureLoader textureWithContentsOfFile:path options:nil error:&error];
    
    //bind to the texture and set magnification and mag parameters
    glBindTexture(GL_TEXTURE_2D, backgroundTexture.name);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    
    [self initGL];
    
    [self initTriangleVBO];
}
-(void) initGL
{
    //set the clear color
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClearDepthf(1.0); //0 being closest 1 being the farthest
    
    //glEnable(GL_CULL_FACE);
    
    glEnable(GL_DEPTH_TEST);
    
    glEnable(GL_TEXTURE_2D);
    
    glScissor(100, 100, 2000, 1000);
    glEnable(GL_SCISSOR_TEST);
    
    //textureID = [self loadTextures];
    
    projectionMatrix = GLKMatrix4Identity;
    //projectionMatrix = GLKMatrix4MakeFrustum(-10.0, 10.0, -10.0, 10.0, 0.1, 100.0);
    float aspect = self.view.bounds.size.width/self.view.bounds.size.height;
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45),aspect ,0.1, 100.0);
    glUniformMatrix4fv(projectionMatrixIndex,1,false,projectionMatrix.m);
    
    
}
-(void)drawTriangle
{
    //enable writing to the position variable
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(colorIndex);
    
    glBindBuffer(GL_ARRAY_BUFFER, triangleVBO);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, GL_FALSE, 28, 0);
    glVertexAttribPointer(colorIndex, 4, GL_FLOAT, GL_FALSE, 28, (void *)12);
    
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, indices);
    
    glDisableVertexAttribArray(colorIndex);
    glDisableVertexAttribArray(positionIndex);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
}
-(void)drawQuad
{
    //make the texture unit 0 active
    glActiveTexture(GL_TEXTURE0);
    
    //bind the texture to active texture unit 0
    glBindTexture(GL_TEXTURE_2D, backgroundTexture.name);
    
    //tell the fragment shader that texture unit 0 is active
    glUniform1i(activeTextureIndex, 0);
    
    
    
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(colorIndex);
    glEnableVertexAttribArray(textureCoordinateIndex);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, false, 36, triangleStrip);
    glVertexAttribPointer(colorIndex, 4, GL_FLOAT, false, 36, triangleStrip + 3);
    glVertexAttribPointer(textureCoordinateIndex, 2, GL_FLOAT, false, 36, triangleStrip + 7);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    
    glDisableVertexAttribArray(positionIndex);
    glDisableVertexAttribArray(colorIndex);
    glDisableVertexAttribArray(textureCoordinateIndex);
}
-(IBAction)changeVertices:(id)sender
{
    
    
    glBindBuffer(GL_ARRAY_BUFFER, triangleVBO);
    
    if(rightTrianglesvertices[0] == 0.5)
        rightTrianglesvertices[0] = 0;
    else
        rightTrianglesvertices[0] = 0.5;
    
    glBufferSubData(GL_ARRAY_BUFFER, sizeof(float)*7, sizeof(float), rightTrianglesvertices);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    
    
}
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //rendering function
    
    //clear the color buffer & depth buffer
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    /*DRAW THE BACKGROUND*/
    //switch the orthographic projection
    projectionMatrix = GLKMatrix4MakeOrtho(-1.0, 1.0, -1.0, 1.0, 0.0, 1.0);
    glUniformMatrix4fv(projectionMatrixIndex, 1, false, projectionMatrix.m);
    modelMatrix = GLKMatrix4Identity;
    glUniformMatrix4fv(modelMatrixIndex, 1, false, modelMatrix.m);
    [self drawQuad];

    
    float aspect = self.view.bounds.size.width/self.view.bounds.size.height;
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60),aspect ,0.1, 100.0);
    glUniformMatrix4fv(projectionMatrixIndex, 1, false, projectionMatrix.m);
    

    glViewport(0, 0, [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale , [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale);
    
    xPosOffset += 0.01;
    if(xPosOffset >= 1.0)
    {
        xPosOffset = -1.0f;
    }
    
    angle += 1.0;
    if(angle >= 360.0)
    {
        angle = 0.0;
    }
    
    scale += 0.01;
    if(scale > 2.0)
    {
        scale = 1.0;
    }
    
    angle2 += 0.2;
    if(angle2 >= 360.0)
    {
        angle2 = 0.0;
    }
    
   
    
    //clear the color buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    zPos += 0.2;
    
    if(zPos > 100.0)
    {
        zPos = 0.0;
    }
    
    zPos =5.0;
    viewMatrix = GLKMatrix4Identity;
    viewMatrix = GLKMatrix4MakeLookAt(0, 0, zPos, 0, 0, 0, 0, 1, 0);
     glUniformMatrix4fv(viewMatrixIndex, 1, false, viewMatrix.m);
    
    
    modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, 0.0, 0.0, -9.0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(angle), 0.0, 1.0, 0.0);
    modelMatrix = GLKMatrix4Scale(modelMatrix, 0.5, 0.5, 0.5);
    glUniformMatrix4fv(modelMatrixIndex, 1, false, modelMatrix.m);
    [sun execute];
    
    
    
    modelMatrix = GLKMatrix4Translate(modelMatrix, 5.0, 0.0, 0.0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(angle+30), 0.0, 1.0, 0.0);
    modelMatrix = GLKMatrix4Scale(modelMatrix, 0.8, 0.8, 0.8);
    glUniformMatrix4fv(modelMatrixIndex, 1, false, modelMatrix.m);
    [earth execute];

    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(10*angle), 0.0, 1.0, 0.0);
    modelMatrix = GLKMatrix4Translate(modelMatrix, 3.0, 0.0, 0.0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(10*angle), 0.0, 1.0, 0.0);
    modelMatrix = GLKMatrix4Scale(modelMatrix, 0.8, 0.8, 0.8);
    glUniformMatrix4fv(modelMatrixIndex, 1, false, modelMatrix.m);
    [moon execute];
    
    
   

    
    //flush the opengl pipeline so that the commands get sent to the GPU
    glFlush();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
