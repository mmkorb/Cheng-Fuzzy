%   Author: Matheus Müller Korb, 2014
%   Se você desejar citar este trabalho, utiliza a seguinte referência: / If you would like to cite this work, please refer to the following paper:
%   MATTOS, V. L. D.; ASMUS, T. C.; MACHADO, C. M. S.; SILVESTRE, I. B. M.; KORB, M. M. Avaliação de um método de transformação de valores crisp em valores fuzzy. GEPROS. Gestão da Produção, Operações e Sistemas, Bauru, Ano 10, nº 4, out-dez/2015, p. 191-205. DOI: 10.15675/gepros.v10i4.1288

%PT: entrada -> executar a função para cada linha que se deseja o valor fuzzy. A entrada é composta de um vetor 'g' no formato descrito abaixo. O formato de saída é um vetor de 3 posicoes que representa um valor Fuzzy.
%EN: input ->  execute the function for each line that the Fuzzy value is desired. The input need to be a vector, like the vector 'g' in the line below. The output is a vector of size 3 representing a Fuzzy value.
%g = [0.55556,1.11111,1.22222,1.66667,1.88889]

function [FUZZY] = cheng(g)
%calcula tamanho da entrada
%calculates the input size
tam=length(g);

%ORDENAR VETOR
%vector sort
g=sort(g);

%cria matriz gxg com coluna subtraindo linha e já coloca os valores em módulo
%creates a gxg matrix with column subtracting row and turn to absolute values.
for i=1:1:tam
    for j=1:1:tam
        D(j,i)=abs(g(i)-g(j));
    end
end

%calculamos as 5 médias de cada linha da matriz anterior os valores ficam dispostos em um vetor
%5 means per line are calculated and the result are arranged in a vector
for i=1:1:tam
    di(i)=0;
    for j=1:1:tam
        di(i)=D(i,j)+di(i);
    end
    di(i)=( (di(i)/(tam-1)) + eps); %COLOQUEI DENTRO DO SOMATORIO -> colocar fora PS.: I think this was corrected.
end

%cria matriz P a partir do vetor encontrado
%creates a P matrix of the vector
for i=1:1:tam
    for j=1:1:tam
        P(i,j)=di(j)/di(i);
    end
end

%encontrar os pesos wi
%searching for the weights
for i=1:1:tam
    n=0;
    for j=1:1:tam
        n=n+P(j,i);
    end
    w(i)=1/n;
end

%encontrar valor central m do numero fuzzy
%the central Fuzzy value are calculated
m=0;
for i=1:1:tam
    m=w(i)*g(i)+m;
end

%até aqui perfeito / at this point all working
%g=sort(g);

%Próximos passos / next steps
%estimar variância das possibilidades / estimate the variance 
%dividir o vetor g em 2 trechos: maior e menor que m / divide the vector 'g' in 2: major and minor than m

%primeiro calcula quantos elementos temos abaixo / first calculates how many elements are
for i=1:1:tam
    teste=i;
    if(g(i)>m)
        teste=teste-1;
        break
    end
end

%agora fazemos o somatorio dos elementos menores / after a sort of the minor elements are made
menores=0; wme=0;

for i=1:1:teste
	menores =menores+ (w(i)*(m-g(i))^2);
    wme=wme+w(i);
end
	menores=menores/wme;
	
%e agora o somatorio dos maiores / and a sort of the major elements are made
maiores=0; wma=0;

	for i=(teste+1):1:tam
		maiores = maiores+(w(i)*(m-g(i))^2);
		wma=wma+ w(i);
	end
maiores=maiores/wma;
%por fim fazemos a média dos somatorios / finally, the means of the major and minor elements
S=(menores+maiores)/2;


%agora encontramos os valores gl e gy / looking for 'gl' and 'gy' values
gl=0; wl=0;
for i=1:1:teste
	gl = gl+(w(i)*g(i));
	wl=wl+w(i);
end
	gl=gl/wl;

gy=0; wy=0;    
for i=(teste+1):1:tam
    gy =gy+(w(i)*g(i));
    wy=wy+w(i);
end
gy=gy/wy;

%agora encontramos o valor de p / looking for 'p' value
if gl==gy
	p=(-1);
else
	p=(m-gl)/(gy-m);
end


%agora encontramos os extremos do fuzzy MUDAR QUANDO m = 0 / finding the extremes of the Fuzzy value
if(m==0)
	a=-eps; b=eps;
else
	xa=(12*(p^2)*(S)) / (1+(p^2));
	a= m - sqrt(xa);
	xb=(12*(S)) / (1+(p^2));
	b= m + sqrt(xb);
end

FUZZY=[a,m,b];

end
