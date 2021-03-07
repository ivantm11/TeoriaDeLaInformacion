clc; clear; close all;

alfabeto = categorical({'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'});
alfabeto_esp = categorical({'A','B','C','D','E','F','G','H','I','J','K','L','M','N','N_','O','P','Q','R','S','T','U','V','W','X','Y','Z'});

libro_esp = 'libros/66paginas.pdf';
libro_eng = 'libros/134ingles.pdf';
libro_fra = 'libros/94fra.pdf';

%% Idioma español

% Probabilidades
p_espanol = obtener_probabilidades_esp(libro_esp);

% Autoinformación
espanolauto = [];           % Vector con valores de la auto información I
for i = 1:length(p_espanol)
   espanolauto(i) = log2(1 / p_espanol(i)); % Calculo de la auto informacion por cada simbolo
end

% Entropia
espanolv_entro = [];        % Vector con valores del producto de la probablidad con la autoinformacion
for i = 1:length(p_espanol)
   espanolv_entro(i) = p_espanol(i) * log2(1 / p_espanol(i)); % Calculo del producto de P*I para cada simbolo
end
espanol_entropia = sum(espanolv_entro); % Valor de la entropia

% Tabla de probabilidades con entropia
tabla_espanol = table(alfabeto_esp',p_espanol',espanolauto', 'VariableNames',{'Simbolo','Probabilidad','Autoinfo'})

%% Idioma inglés

% Probabilidades
p_ingles = obtener_probabilidades(libro_eng);

% Autoinformación
inglesauto = [];           % Vector con valores de la auto información I
for i = 1:length(p_ingles)
   inglesauto(i) = log2(1 / p_ingles(i)); % Calculo de la auto informacion por cada simbolo
end

% Entropia
inglesv_entro = [];        % Vector con valores del producto de la probablidad con la autoinformacion
for i = 1:length(p_ingles)
   inglesv_entro(i) = p_ingles(i) * log2(1 / p_ingles(i)); % Calculo del producto de P*I para cada simbolo
end
ingles_entropia = sum(inglesv_entro); % Valor de la entropia

% Tabla de probabilidades con entropia
tabla_ingles = table(alfabeto',p_ingles',inglesauto', 'VariableNames',{'Simbolo','Probabilidad','Autoinfo'})

%% Idioma francés

% Probabilidades
p_frances = obtener_probabilidades(libro_fra);

% Autoinformación
francesauto = [];           % Vector con valores de la auto información I
for i = 1:length(p_frances)
   francesauto(i) = log2(1 / p_frances(i)); % Calculo de la auto informacion por cada simbolo
end

% Entropia
francesv_entro = [];        % Vector con valores del producto de la probablidad con la autoinformacion
for i = 1:length(p_frances)
   francesv_entro(i) = p_frances(i) * log2(1 / p_frances(i)); % Calculo del producto de P*I para cada simbolo
end
frances_entropia = sum(francesv_entro); % Valor de la entropia

% Tabla de probabilidades con entropia
tabla_frances = table(alfabeto',p_frances',francesauto', 'VariableNames',{'Simbolo','Probabilidad','Autoinfo'})
