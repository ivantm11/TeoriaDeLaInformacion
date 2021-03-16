clc; clear; close all;
%% Alfabeto en español
alfabeto_esp = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','Ñ','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

%%  Probabilidades del libro en español
libro_esp = 'libros/libro-esp.pdf';
p_espanol = obtener_probabilidades_esp(libro_esp);

%%  Preparación
% Ordenamiento del vector de probabilidades de mayor a menor
%   p_espanol_ordenado -> probabilidades ordenadas
%   indices_original   -> indices correspondientes de p_espanol respecto al nuevo
%                         array ordenado
[p_espanol_ordenado, indices_original] = sort(p_espanol, 'descend');
elementos_alfabeto = length(p_espanol); 

% Se define una matriz de estructuras donde cada struct representa un nodo
% de un árbol, de tal forma que cada struct tiene un padre, hijos izq y der,
% una probabilidad y una extensión en caso de que no tenga padre.
arbol(elementos_alfabeto,elementos_alfabeto) = struct('prob', 0, 'izq', 0, 'der', 0, 'ext', 0, 'padre', 0);

%Inicialización de los valores de los nodos
for i = 1:elementos_alfabeto
    for j = 1:elementos_alfabeto
        arbol(i, j).prob = 0;
        arbol(i, j).izq = 0;
        arbol(i, j).der = 0;
        arbol(i, j).ext = 0;
        arbol(i, j).padre = 0;
    end
end

%%  Algoritmo de Huffman
% Para comenzar con el algoritmo de Huffman, se deben de asignar las
% probabilidades del libro analizado, que ya estan ordenadas, a las hojas
% del árbol de Huffman para avanzar con la creación de los códigos por
% símbolo.
for i = 1:elementos_alfabeto
    arbol(i, 1).prob = p_espanol_ordenado(i); % Se asigna cada probabilidad a la "probabilidad" de cada hoja
end

% Definimos una estructura auxiliar para el algoritmo Bubble sort, empleado
% en Huffman
struct_auxiliar = struct ('prob', 0, 'izq', 0, 'der', 0, 'ext', 0, 'padre', 0);

for i = 1:(elementos_alfabeto - 1)
    % Se crea el nuevo nodo del siguiente nivel al combinar los dos nodos de 
    % menor probabilidad en un solo para el siguiente nivel del árbol.
    
    % El nuevo nodo contiene la suma de las probabilidades mas pequeñas del nivel anterior
    arbol(elementos_alfabeto - i, i + 1).prob = arbol(elementos_alfabeto - i, i).prob + arbol(elementos_alfabeto - i + 1, i).prob; 
    % Asigna el hijo izquierdo
    arbol(elementos_alfabeto - i, i + 1).izq = elementos_alfabeto - i;
    % Asigna el hijo derecho
    arbol(elementos_alfabeto - i, i + 1).der = elementos_alfabeto - i + 1;
    
    %Los nodos sobrantes que no fueron combinados, sólo se extienden a los nodos del siguiente nivel
    for j = 1:(elementos_alfabeto - i - 1)
         arbol(j, i + 1).prob = arbol(j, i).prob;   % Se asigna la probabilidad
         arbol(j, i + 1).ext = j;                   % Se guarda a que indice del nivel anterior pertenece la extensión
    end
        
    % Ahora se deben ordenar los nuevos nodos del nivel de forma descendente
    % Se usa el algoritmo bubble sort 
    for j = (elementos_alfabeto - i):-1:2 
       if (arbol(j-1,i+1).prob < arbol(j,i+1).prob) 
            struct_auxiliar = arbol(j,i+1);     % Almacenar temporalmente el nodo a cambiar
            arbol(j,i+1) = arbol(j-1,i+1);      % Cambio de nodo
            arbol(j-1,i+1) = struct_auxiliar;   % Reestablecimiento del nodo guardado en su nueva posición
       else            
            break;
       end
    end
    
    % Ya que se ordenó el nuevo nivel, ahora asignaremos las conexiones a
    % nodos del nivel anterior a sus nuevos padres o extensiones según
    % aplique
    for j = 1:(elementos_alfabeto - i)
        if ((arbol(j,i+1).ext) ~= 0)
            % Si el nodo tiene extensión, se asigna el indice de extensión
            % correspondiente
            arbol(arbol(j,i+1).ext,i).ext=j;
        else
            % Si el nodo tiene padre, se asignan los índices de este
            arbol(arbol(j, i + 1).izq, i).padre = j;
            arbol(arbol(j, i + 1).der, i).padre = j;
        end
     end
 
end

%% Obtención de códigos para cada símbolo
% Ya que tenemos el árbol de probabilidades, se sigue el camino generado
% por cada símbolo y los unos y ceros se irán acumulando: si proviene del
% hijo izquierdo se asigna un cero, si es del hijo derecho un uno; en las
% extensiones no se agrega un número

% Inicialización de la matriz que almacenará los códigos
% Tener en cuenta que debemos comenzar con valores nulos, en este caso se
% usará el número 5 como nulo
matriz_codigos = zeros(elementos_alfabeto, elementos_alfabeto);
for i = 1:elementos_alfabeto
    for j = 1:elementos_alfabeto
        matriz_codigos(i, j) = 5;
    end
end

% Se siguen los caminos generados en el árbol de probabilidades para cada
% uno de los elementos del alfabeto
for i = 1:elementos_alfabeto 
    % Se usará index_camino para indicar el indice del nodo que sigue en el
    % camino del símbolo que se inicializa en cada interacción de las hojas
    % del árbol
    index_camino = i;
    % Barrido sobre todos los niveles del arbol para seguir el camino
    for j = 1:elementos_alfabeto 
        % Si el nodo actual tiene padre, se debe preguntar si el nodo
        % hijo es el izquierdo o derecho para poder agregar un cero o
        % uno
        if(arbol(index_camino,j).padre ~= 0)
            % Si es el hijo izquierdo, se agrega un cero
            if(arbol(arbol(index_camino, j).padre, j + 1).izq == index_camino)
                matriz_codigos(indices_original(i), elementos_alfabeto - j + 1) = 0;
            % Si es el hijo derecho, se agrega un uno
            elseif(arbol(arbol(index_camino, j).padre, j + 1).der == index_camino)
                matriz_codigos(indices_original(i), elementos_alfabeto - j + 1) = 1;
            end
            % Al final se actualiza el índice ahora hacia el valor del padre
            index_camino = arbol(index_camino,j).padre; 
        % Si no, se actualiza el índice al valor de la extensión
        else
            index_camino = arbol(index_camino,j).ext; 
        end
    end
end

%% Adecuación/compresión de la matriz de códigos
% Como la matriz es cuadrada elementos_alfabeto X elementos_alfabeto, se
% busca el código de mayor tamaño para decidir el ancho máximo de la matriz
% y al final colocar los códigos

% Vector que guarda las longitudes de cada código
longitudes_codigo = zeros(1,elementos_alfabeto);
% Recorremos la matriz de códigos
for i = 1:elementos_alfabeto 
    for j = 1:elementos_alfabeto
        % Si el valor es no nulo (cero o uno) en la posición visitada, se aumenta el
        % contador de longitud de cada código
        if(matriz_codigos(i,j) == 0 || matriz_codigos(i,j) == 1)
            longitudes_codigo(i) = longitudes_codigo(i)+1;
                                              
        end
    end
end

% Generación de la nueva matriz compactada
% Se guarda la longitud máxima de todas las longitudes obtenidas
maxima_longitud = max(longitudes_codigo); 
% Inicialización de matriz comprimida
codigo_final = repmat(' ',[elementos_alfabeto maxima_longitud]);

% Transferencia de datos a la nueva matriz compactada
% Índice auxiliar para transferir los datos
index_aux = 1;
% Recorremos la matriz de códigos
for i = 1:elementos_alfabeto
    for j = 1:elementos_alfabeto
        % Si el código es UNO
        if(matriz_codigos(i, j) == 1)
            % Se asigna ese UNO a la nueva matriz
            codigo_final(i, index_aux) = '1';
            % Aumentamos índice auxiliar
            index_aux = index_aux + 1;
        elseif(matriz_codigos(i,j) == 0)
            % Se asigna ese CERO a la nueva matriz
            codigo_final(i, index_aux) = '0';
            % Aumentamos índice auxiliar
            index_aux = index_aux + 1;
        end
        % El aumento del índice auxiliar se hace dentro de las
        % comprobaciones de cero o uno para omitir los valores nulos
    end
    % Reiniciamos el índice para usarlo en el siguiente código de la
    % siguiente palabra
    index_aux = 1;
end

%% Muestra de resultados
tabla_resultados = table(alfabeto_esp', p_espanol', codigo_final, 'VariableNames', {'Símbolo', 'Probabilidad', 'Codigo de Huffman'})
