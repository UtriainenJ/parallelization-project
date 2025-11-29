// Stores 2D data like the coordinates
typedef struct{
   float x;
   float y;
} floatvector;

// Each float may vary from 0.0f ... 1.0f
typedef struct{
   float blue;
   float green;
   float red;
} color_f32;

// Stores rendered colors. Each value may vary from 0 ... 255
typedef struct{
   uchar blue;
   uchar green;
   uchar red;
   uchar reserved;
} color_u8;

// Stores the satellite data, which fly around black hole in the space
typedef struct{
   color_f32 identifier;
   floatvector position;
   floatvector velocity;
} satellite;

typedef struct{
   int windowHeight;
   int windowWidth;
   int size;
   int satelliteCount;
   float satelliteRadius;
   float blackHoleRadius;
} Constants;

__kernel void graphicsEngine(
                            __global Constants* c,
                            __global color_u8* pixels,
                            __global satellite* satellites,
                            int mousePosX, int mousePosY) {
   int windowHeight = c->windowHeight;
   int WINDOW_WIDTH = c->windowWidth;
   int SIZE = c->size;
   int SATELLITE_COUNT = c->satelliteCount;
   float SATELLITE_RADIUS = c->satelliteRadius;
   float BLACK_HOLE_RADIUS = c->blackHoleRadius;


    // Graphics pixel loop
   
   //int i = get_global_id(0);
   // Row wise ordering
   //floatvector pixel = {.x = i % WINDOW_WIDTH, .y = i / WINDOW_WIDTH};

   floatvector pixel = {.x = get_global_id(0), .y = get_global_id(1)};
   int i = pixel.y * WINDOW_WIDTH + pixel.x;

   // Draw the black hole
   floatvector positionToBlackHole = {.x = pixel.x -
      mousePosX, .y = pixel.y - mousePosY};
   float distToBlackHoleSquared =
      positionToBlackHole.x * positionToBlackHole.x +
      positionToBlackHole.y * positionToBlackHole.y;
   float distToBlackHole = sqrt(distToBlackHoleSquared);
   if (distToBlackHole < BLACK_HOLE_RADIUS) {
      pixels[i].red = 0;
      pixels[i].green = 0;
      pixels[i].blue = 0;
      return; // Black hole drawing done
   }

   // This color is used for coloring the pixel
   color_f32 renderColor = {.red = 0.f, .green = 0.f, .blue = 0.f};

   // Find closest satellite
   float shortestDistance = INFINITY;

   float weights = 0.f;
   int hitsSatellite = 0;

   // First Graphics satellite loop: Find the closest satellite.
   int j;
   for(j = 0; j < SATELLITE_COUNT; ++j){
      floatvector difference = {.x = pixel.x - satellites[j].position.x,
                                 .y = pixel.y - satellites[j].position.y};
      float distance = sqrt(difference.x * difference.x +
                              difference.y * difference.y);

      if(distance < SATELLITE_RADIUS) {
         renderColor.red = 1.0f;
         renderColor.green = 1.0f;
         renderColor.blue = 1.0f;
         hitsSatellite = 1;
         break;
      } else {
         float weight = 1.0f / (distance*distance*distance*distance);
         weights += weight;
         if(distance < shortestDistance){
            shortestDistance = distance;
            renderColor = satellites[j].identifier;
         }
      }
   }

   // Second graphics loop: Calculate the color based on distance to every satellite.
   if (!hitsSatellite) {
      for(int k = 0; k < SATELLITE_COUNT; ++k){
         floatvector difference = {.x = pixel.x - satellites[k].position.x,
                                    .y = pixel.y - satellites[k].position.y};
         float dist2 = (difference.x * difference.x +
                        difference.y * difference.y);
         float weight = 1.0f/(dist2* dist2);

         renderColor.red += (satellites[k].identifier.red *
                              weight /weights) * 3.0f;

         renderColor.green += (satellites[k].identifier.green *
                                 weight / weights) * 3.0f;

         renderColor.blue += (satellites[k].identifier.blue *
                              weight / weights) * 3.0f;
      }
   }
   pixels[i].red = (uchar) (renderColor.red * 255.0f);
   pixels[i].green = (uchar) (renderColor.green * 255.0f);
   pixels[i].blue = (uchar) (renderColor.blue * 255.0f);
}