
clear 
clc





%%Parametros del globulo
q=+(0.5);
m = 0.05;
%% Condiciones iniciales
x0 = 0; % Posición inicial en x
y0 = 2; % Posición inicial en y
vx0 = 0; % Velocidad inicial en x
vy0 = 0; % Velocidad inicial en y

%% Paso dle tiempo y numero de pasos
dt = 0.00000000015; % Paso de tiempo
num_pasos = 1000;



%% Parámetros del espacio
num_puntos = 300; % Número de puntos en la cuadrícula
rw=0.01;
x_min = -5; x_max = 5; y_min = -3; y_max = 3; % Límites del espacio
y_values = linspace(y_min, y_max, num_puntos); % Coordenadas y
x_values = linspace(x_min, x_max, num_puntos); % Coordenadas x

%% Incializar vectores para almacenar la trayectoria 
x_traj = zeros(num_puntos, 1);
y_traj = zeros(num_puntos, 1);
vx_traj = zeros(num_puntos, 1);
vy_traj = zeros(num_puntos, 1);

%% Definición de cargas y constantes
carga_total = 100;   % Carga total en Coulombs
epsilon_0 = 8.85e-12; % Permitividad del vacío
constante_k = 8.99e9; % Constante de Coulomb

%% Dimensiones y separación de las placas cargadas
longitud_placa_positiva =  1;
longitud_placa_negativa = 2;
separacion_entre_placas = 3.4;

%% Número de elementos de carga
num_elementos_carga = 5;

%% caculo de fuerza para el blobulo rojo variables
diametro = 2;
r1= zeros(num_puntos, 1);
r2= zeros(num_puntos, 1);
r3=zeros(num_puntos, 1);
r4=zeros(num_puntos, 1);

f1= zeros(num_puntos, 1);
f2= zeros(num_puntos, 1);
f3=zeros(num_puntos, 1);
f4=zeros(num_puntos, 1);

ftotal=zeros(num_puntos, 1);

qery = -80;
qplaca = 6;

%% Posiciones de los elementos de carga
x_elem_pos = -separacion_entre_placas / 2 + zeros(1, num_elementos_carga);
x_elem_neg = separacion_entre_placas / 2 + zeros(1, num_elementos_carga);
y_elem_pos = linspace(-longitud_placa_positiva / 2, longitud_placa_positiva / 2, num_elementos_carga);
y_elem_neg = linspace(-longitud_placa_negativa / 2, longitud_placa_negativa / 2, num_elementos_carga);

%% Cálculo del potencial eléctrico
diferencial_carga =  carga_total/num_elementos_carga;
potencial = zeros(num_puntos, num_puntos);

for i = 1:num_puntos
    for j = 1:num_puntos
        for k = 1:num_elementos_carga
            r_pos = rw + sqrt((x_values(i)-x_elem_pos(k))^2 + (y_values(j)-y_elem_pos(k))^2);
            r_neg = rw + sqrt((x_values(i)-x_elem_neg(k))^2 + (y_values(j)-y_elem_neg(k))^2);
            V_pos = -constante_k * diferencial_carga / r_pos; 
            V_neg = +constante_k * diferencial_carga / r_neg;

            potencial(i,j) = potencial(i,j) + V_pos + V_neg;
            r1(i)=x_elem_pos(k)-(x_values(i)-diametro/2);
            r2(i)=x_elem_pos(k)-(x_values(i)-diametro/2);
            r3(i)=x_elem_neg(k)-(x_values(i)-diametro/2);
            r4(i)=x_elem_neg(k)-(x_values(i)-diametro/2);

            f1(i)=constante_k*qery*qplaca/r1(i)^2;
            f2(i)=constante_k*qery*qplaca/r2(i)^2;
            f3(i)=constante_k*qery*qplaca/r3(i)^2;
            f4(i)=constante_k*qery*qplaca/r4(i)^2;

            ftotal(i)=f3(i)+f2(i)+f1(i)+f4(i);
            
        end
    end
end





%% Calcular el campo eléctrico (gradiente del potencial)
[Ex, Ey] = gradient(potencial');
%x+d/2, y
%una positiva y negativa
%



%% Graficar el potencial eléctrico
pcolor(x_values, y_values, -potencial');
shading flat;
colormap turbo;
colorbar;

%% Graficar las líneas de campo eléctrico
streamslice(x_values, y_values, Ex, Ey);

hold on;
grid on;



% Configuración de la gráfica
%axis([x_min, x_max, y_min, y_max]); % Establecer los límites del eje
plot(x_elem_neg, y_elem_neg, 'ob', 'LineWidth', 3); % Placa negativa
plot(x_elem_neg, y_elem_neg, '_k', 'LineWidth', 2); % Marcadores
plot(x_elem_pos, y_elem_pos, 'or', 'LineWidth', 3); % Placa positiva
plot(x_elem_pos, y_elem_pos, '+k', 'LineWidth', 2); % Marcadores



xlabel('Posición en x'); % Etiqueta del eje x
ylabel('Posición en y'); % Etiqueta del eje y
title('Trayectoria del objeto cargado'); % Título de la gráfica


                     
for repetition = 1:randi([2, 6])
    random_direction = randi([-4, 4]);
    x = x0;
    y = y0;
    vx = vx0;
    vy = vy0;
    for i = 1:num_puntos
    % Calcular la aceleración en x y y
    
    %% F/m
    ax = (ftotal(i)*random_direction) / m;
    ay = 0;
    
    % Actualizar la velocidad en x y y
    vx = vx + ax * dt;
    vy = -200000001;
    
    % Actualizar la posición en x y y
    x = x + vx * dt;
    y = y + vy * 0.000000000065;
    
    % Almacenar la trayectoria
    x_traj(i) = x;
    y_traj(i) = y;
    vx_traj(i) = vx;
    vy_traj(i) = vy;
    end
    % Animar la trayectoria y la partícula
    % Crear la línea animada para la trayectoria
    line = animatedline('Color', 'm', 'LineWidth', 2);
    diametro = 0.1; % Diámetro del círculo
    % Crear el círculo animado para la partícula
    particle = rectangle('Position', [x_traj(1)-0.05, y_traj(1), diametro, diametro],'Curvature', [1, 1], 'FaceColor', 'y');
    for i = 1:length(x_traj)
        % Actualizar la posición de la línea de trayectoria
        addpoints(line, x_traj(i), y_traj(i));
    
        % Actualizar la posición del círculo de la partícula
        set(particle, 'Position', [x_traj(i)-0.05, y_traj(i), diametro, diametro]);
    
        drawnow;
        pause(0.01); % Ajusta la velocidad de la animación modificando este valor
    end
end