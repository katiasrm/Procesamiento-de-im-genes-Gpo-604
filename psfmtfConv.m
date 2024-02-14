f=imread('radiograph1.jpg');
imshow(f);
%Aqui nos muestra la imagen en blanco y negro
%%
f=double(f(:,:,1))/255.0;%Solo sacamos un color el 1, cuando podemos el 255 porque lo volteamos
subplot(2,2,2);
imshow(f);
%Lo vamos a pasar a la escala de gris
%%
%g=f*h (f es el transfer function)
f=imresize(f,0.25);

figure(1);
subplot(2,2,1);

imshow(f,[]);
%mesh(f);
%% Convolucion
h=fspecial('disk',10);
subplot(2,2,3);
mesh(h); %disco que cada punto de la imagen esta pasando por el sol y esta mostrando la sombra

g=conv2(f,h,'same'); %funcion matematica que hace el proceso de imitar
subplot(2,2,4);
mesh(g);

subplot(2,2,2); %vemos la representacion como funcion matematica e imagen. 
imshow(g);

%% 
%Estamos selecionando un puntito que lo vamos a convertir en circulo (discos=sombra)
sz=size(f);
fdot = zeros(sz(1),sz(2));
fdot(int16(sz(1)/2),int16(sz(2)/2))=1;
fdot(int16(sz(1)/3),int16(sz(2)/2))=1; %agregamos otros dos puntos
fdot(int16(sz(1)/2),int16(sz(2)/3))=1;
subplot(2,2,1);
imshow(fdot);


h=fspecial('gaussian',17,4);
subplot(2,2,3);
mesh(h);



g=conv2(fdot,h,'same'); 
subplot(2,2,4);
mesh(g);


g=conv2(f,h,'same'); 
subplot(2,2,2);
imshow(g);


%% Imagen como senos y cosenos

sineimage=zeros(sz(1),sz(2));
for (x=1:sz(1))
    for(y=1:sz(2))
        f(y,x)=sin(x*0.1);
        sineimage(y,x)=sin((y+x)*0.1)*sin((x-y)*0.6); %podemos cambiar los ejes entre x o y, tambien se pueden juntar para ver frecuencias en todos los ejes, o combinarlos

    end
end
figure(2);
subplot(2,2,1);
imshow(sineimage,[]);
subplot(2,2,2);
mesh(sineimage)

F=fft2(sineimage,sz(1),sz(2)); %separacion de frecuencias mas grande, frecuencia en y separacion mas angosta, bajamos la frecuencia de y de *0.1 a *0.2. Cambiamos la frecuencia de x de *0.5 a *1.0, muy alta. Afecta la separacion en x & y
subplot(2,2,3);
imshow(ffshift(abs(F)),[]);

subplot(2,2,4);
mesh(ffshift(abs(F)));

%%
figure(1)
subplot(2,2,1);
imshow(f,[]);

F=fft2(f,sz(1),sz(2));%fourier digital
h=fspecial('disk',10); %un function de disco que representa las ondas de fuentes extendidas
H=fft2(h,sz(1),sz(2)); %convolucion con H
G=F.*H; %is almost the same as conv2(f,h)
g=abs(ifft2(G));

subplot(2,2,2);
imshow(g,[]); %imagen 2

G=F.*abs(H); %quitarle la fase, artefacto de fourier
g=abs(ifft2(G));
subplot(2,2,3);
imshow(g,[]);%F*absH
g2 = conv2(f,h,'same'); 

subplot(2,2,4);
imshow(g2,[]); %f*h convolucion



%convolucion es la integral de la integreal de F(x,y)absH(x,y)