# Tarea 1 - Entropía

## Archivo principal
[Tarea1Entropia.m](Tarea1Entropia.m) <br>
Configurar los archivos a leer en cada caso:
``` Matlab
libro_esp = 'ruta-a-texto-en-español';
libro_eng = 'ruta-a-texto-en-inglés';
libro_fra = 'ruta-a-texto-en-francés';
```
Este es el archivo que se ejecuta y entrega los resultados solicitados

## Archivos secundarios
### Función de probabilidades con Ñ/ñ (idioma español)
[obtener_probabilidades_esp.m](obtener_probabilidades_esp.m) <br>
Esta función **cuenta** en el calculo de las probabilidades al símbolo Ñ <br>
Regresa un vector con las probabilidades de cada símbolo en orden alfabético

### Función de probabilidades sin Ñ/ñ
[obtener_probabilidades.m](obtener_probabilidades.m) <br>
Esta función **descarta** en el calculo de las probabilidades al símbolo Ñ/ñ <br>
Regresa un vector con las probabilidades de cada símbolo en orden alfabético

## Resultados
### Idioma español
![resultEsp]

### Idioma inglés
![resultEng]

### Idioma francés
![resultFra]

---

_Last update March 7<sup>th</sup> 2021_<br>
_Created by Ivan Trejo_

[resultEsp]: resultados/resultados_esp.png "Tabla de probabilidades y auto información idioma español"
[resultEng]: resultados/resultados_eng.png "Tabla de probabilidades y auto información idioma inglés"
[resultFra]: resultados/resultados_fra.png "Tabla de probabilidades y auto información idioma francés"
