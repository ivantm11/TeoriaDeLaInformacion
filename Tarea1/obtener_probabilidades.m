function [vector] = obtener_probabilidades(archivo)
    c_especiales = 0;   % Contador para caracteres especiales
    tipos_a = 0;    % Contador para variantes de A
    tipos_e = 0;    % Contador para variantes de E
    tipos_i = 0;    % Contador para variantes de I
    tipos_o = 0;    % Contador para variantes de O
    tipos_u = 0;    % Contador para variantes de U

    vector = [];    % Vector que regresa las probabilidades en orden alfabetico

    letras = extractFileText(archivo);      % Extraccion del texto desde el archivo
    total_letras = length(char(letras));    % Total de letras en el texto del archivo
    letrasUpper = upper(letras);            % Convertimos todo el txt a mayusculas para facilitar la busqueda

    % Se detectan y contabilizan los caracteres especiales para restarlos en el calculo de la probabilidad

    % Identificando caracteres especiales
    % Tabla ASCII consultada: https://elcodigoascii.com.ar

    %' !"#$%&'()*+,-./' ASCII(32-47)
    for r = 32:47
        simbolo = char(r);                              % Convirtiendo de código ASCII a símbolo.
        total = length(strfind(letrasUpper, simbolo));   % Buscando el numero de ocurrencias
        c_especiales = c_especiales + total;            % Aumentando el contador de especiales
        total = 0;                                      % Limpiando el contador para el proximo simbolo
    end

    %':;<=>?@' ASCII(58-64)
    for r = 58:64
        simbolo = char(r);                              % Convirtiendo de código ASCII a símbolo.
        total = length(strfind(letrasUpper, simbolo));   % Buscando el numero de ocurrencias
        c_especiales = c_especiales + total;            % Aumentando el contador de especiales
        total = 0;                                      % Limpiando el contador para el proximo simbolo
    end    

    %'[\]^_`' ASCII(91-96)
    for r = 91:96
        simbolo = char(r);                              % Convirtiendo de código ASCII a símbolo.
        total = length(strfind(letrasUpper, simbolo));   % Buscando el numero de ocurrencias
        c_especiales = c_especiales + total;            % Aumentando el contador de especiales
        total = 0;                                      % Limpiando el contador para el proximo simbolo
    end    

    %'{|}~???????????????????????????????? ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾
    %¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ'
    %ASCII (123-255)
    for r = 123:255
        % Caso â = ä = à = å = Ä = Å = á = Á = Â = À = ã = Ã
        if(r == 131 || r == 132 || r == 133 || r == 134 || r == 142 || r == 143 || r == 160 || r == 181 || r == 182 || r == 183 || r == 198 || r == 199)
            otro = char(r);
            tipos_a = tipos_a + length(strfind(letrasUpper, otro)); % Buscando el numero de ocurrencias
        % Caso é = ê = ë = è = É = Ê = Ë = È
        elseif(r ==130 || r == 136 || r == 137 || r ==138 || r == 144 || r == 210 || r == 211 || r == 212)
            otro = char(r);
            tipos_e = tipos_e + length(strfind(letrasUpper, otro)); % Buscando el numero de ocurrencias
        % Caso ï = î = ì = í = Í = Î = Ï
        elseif(r == 139 || r == 140 || r ==141 || r == 161 || r == 214 || r == 215 || r == 216)
            otro = char(r);
            tipos_i = tipos_i + length(strfind(letrasUpper, otro)); % Buscando el numero de ocurrencias
        % Caso ô = ö = ò = Ö = ø = Ø = ó = Ó = Ô = Ò = õ = Õ
        elseif(r == 147 || r == 148 || r == 149 || r == 153 || r == 155 || r == 157 || r == 162 || r == 224 || r == 226 || r == 227 || r == 228 || r == 229)
            otro = char(r);
            tipos_o = tipos_o + length(strfind(letrasUpper, otro)); % Buscando el numero de ocurrencias
        % Caso ü = û = ù = Ü = ú = Ú = Û = Ù
        elseif(r == 129 || r ==150 || r == 151 || r == 154 || r == 163 || r == 233 || r == 234 || r == 235)
            otro = char(r);
            tipos_u = tipos_u + length(strfind(letrasUpper, otro)); % Buscando el numero de ocurrencias
        else   
            simbolo = char(r);                              % Convirtiendo de código ASCII a símbolo.
            total = length(strfind(letrasUpper, simbolo));   % Buscando el numero de ocurrencias
            c_especiales = c_especiales + total;            % Aumentando el contador de especiales
            total = 0;                                      % Limpiando el contador para el proximo simbolo
        end
    end

    n = 1;  % Indice para letras del alfabeto en el resultado devuelto
    for j = 65:90 % Contabilizando mayusculas A-Z
        letra = char(j);                                % Convirtiendo el inidice del for a Caracter (ASCII-Letra)
        total = length(strfind(letrasUpper, letra));     % Buscando el numero de ocurrencias

        % Agregamos las variaciones de las vocales
        % Caso A
        if(j == 65)
            total = total + tipos_a;
        % Caso E
        elseif(j == 69)
            total = total + tipos_e;
        % Caso I
        elseif(j == 73)
            total = total + tipos_i;
        % Caso O
        elseif(j == 79)
            total = total + tipos_o;
        % Caso U
        elseif(j == 85)
            total = total + tipos_u;
        end

        proba = total / (total_letras - c_especiales);  % Calculo de la probabilidad omiento caracretes especiales
        vector(n) = proba;                              % Llenando el vector de probabilidades
        
        n = n + 1;  % Actualizacion de indice para vector de probabilidades
        total = 0;  % Limpiando el contador para el proximo simbolo
    end
end
