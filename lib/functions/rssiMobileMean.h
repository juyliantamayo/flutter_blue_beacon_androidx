/* Funciones para suavizar un conjunto de datos RSSI en un array 1D. En primer lugar se calcula la media y la desviación estandar.
Seguidamente se recorre el array para descartar valores atipicos a traves del criterio de puntuación Z. Los datos no
atipicos se almacenan en un nuevo array y se aplica un filtro de media movil. al final se saca la media de los datos filtrados*/

#include <iostream>
#include <math.h>
#include <vector>

#ifndef _rssiMeanMovil_h
#define _rssiMeanMovil_h

using namespace std;

const int windowSize = 10;
float circularBuffer[windowSize];
float* circularBufferChange = circularBuffer;

float sum;
int elementCount;
float mean;

 
int appendToBuffer(float value)
{
  *circularBufferChange = value;
  circularBufferChange++;
  if (circularBufferChange >= circularBuffer + windowSize) 
    circularBufferChange = circularBuffer;
  return 0;
}

float AddValueRssi(float value)
{
  sum -= *circularBufferChange;
  sum += value;
  appendToBuffer(value);
 
  if (elementCount < windowSize)
    ++elementCount;
  return (float) sum / elementCount;
}
 
template< std::size_t N >
float GetValueRssi(float (&rawRssi)[N])
{
  	float valRssi;
    float mean ;
    int valuesLength = sizeof(rawRssi) / sizeof(float);
  	size_t static index = 0;

	float media = 0;
	float meanMovil = 0;
	float varianza = 0;
	float desviacionStandar = 0;
	 
	for(int e = 0;e < valuesLength;e++)
    {
         media = media + rawRssi[e];//se hace la sumatoria y se guarda los valores
    }
	media = media / valuesLength;

	for(int k = 0;k < valuesLength;k++)
	{
		varianza = varianza + (((rawRssi[k])-(media))*((rawRssi[k])-(media)));
		/*se hace la sumatoria del cuadrado de sumatoria - media*/
	}
	varianza = varianza / valuesLength;//se hace la divicion de la suma anterior con la cantidad

	desviacionStandar = sqrt(varianza);
	cout <<"desviación estandar:" <<desviacionStandar <<endl;

   //Puntuación Z  (x(i)-media)/desviación 
   float puntuacionZ = 0;
   int n, posicion=0;
   vector<float> arreglo={0};

   	for (int j = 0; j < valuesLength; j++)
	{		
		valRssi = rawRssi[j];
		puntuacionZ = (valRssi-media)/desviacionStandar;
		if ((puntuacionZ > -3) || (puntuacionZ < 3))
		{
			arreglo[posicion] = valRssi;
		    arreglo.resize(arreglo.size() +1);
			posicion ++;   			
		}			
	}
	arreglo.resize(arreglo.size() - 1);
    
	for (int index = 0; index < posicion; index++)
	{
		valRssi = arreglo[index];
		mean = AddValueRssi(valRssi);
		meanMovil = meanMovil + mean;      
	}
	meanMovil = meanMovil/posicion;
	return meanMovil;
}

#endif