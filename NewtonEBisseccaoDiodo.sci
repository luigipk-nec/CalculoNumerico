clear
clc

//Constantes do circuito
I_s = 1e-12;         //Corrente de saturação do diodo (A)
n = 1;               //Fator de idealidade do diodo
V_t = 0.025;         //Tensão térmica (V)
V_s = 5;             //Fonte de tensão (V)
R = 1000;            //Resistência (ohms)

//Função do diodo/lei kirchoff
f = 'I_s * (exp(V_d / (n * V_t)) - 1) - (V_s - V_d) / R';
df = 'I_s * (1 / (n * V_t)) * exp(V_d / (n * V_t)) + 1 / R';

//Parâmetros de entrada do usuário
a1 = input('Entre com o chute inicial para o metodo de Newton (V_d inicial): ');
a_bis = input('Entre com o limite inferior do intervalo para o metodo da Bisseccao: ');
b_bis = input('Entre com o limite superior do intervalo para o metodo da Bisseccao: ');
tol = input('Entre com a tolerancia de erro desejada: ');

//---------- Newton ----------
printf("\nMétodo de Newton:\n");
t_newton = 1;
a(t_newton) = a1;
erro_newton(t_newton) = %inf;

while erro_newton(t_newton) > tol
    V_d = a(t_newton);              //Valor atual de V_d
    fa(t_newton) = evstr(f);        //Avalia f(V_d)
    dfa(t_newton) = evstr(df);      //Avalia f'(V_d)
    nf(t_newton) = a(t_newton) - (fa(t_newton) / dfa(t_newton));    //Próximo valor de V_d usando Newton
    a(t_newton+1) = nf(t_newton);          //Atualiza V_d
    erro_newton(t_newton+1) = abs(a(t_newton+1) - a(t_newton));     //Calcula o erro
    t_newton = t_newton + 1;
end

//Exibe os resultados de Newton
printf('Iteracao\t V_d\t\t f(V_d)\t\t f`(V_d)\t nf\t\t Erro\n');
for i = 1:t_newton-1
    printf('%d\t\t %f\t %f\t %f\t %f\t %e\n', i, a(i), fa(i), dfa(i), nf(i), erro_newton(i));
end

//---------- Bissecção ----------
printf("\nMétodo da Bissecção:\n");
t_bissec = 1;
a_bis_vec(t_bissec) = a_bis;
b_bis_vec(t_bissec) = b_bis;
erro_bissec(t_bissec) = abs(b_bis_vec(t_bissec) - a_bis_vec(t_bissec));

while erro_bissec(t_bissec) > tol
    xm(t_bissec) = (a_bis_vec(t_bissec) + b_bis_vec(t_bissec)) / 2;
    V_d = xm(t_bissec);
    fxm(t_bissec) = evstr(f);      //Avalia f(xm)
    V_d = a_bis_vec(t_bissec);
    fa_bis(t_bissec) = evstr(f);   //Avalia f(a)
    V_d = b_bis_vec(t_bissec);
    fb_bis(t_bissec) = evstr(f);   //Avalia f(b)

    if (fa_bis(t_bissec) * fxm(t_bissec)) < 0
        a_bis_vec(t_bissec+1) = a_bis_vec(t_bissec);
        b_bis_vec(t_bissec+1) = xm(t_bissec);
    else
        a_bis_vec(t_bissec+1) = xm(t_bissec);
        b_bis_vec(t_bissec+1) = b_bis_vec(t_bissec);
    end

    t_bissec = t_bissec + 1;
    erro_bissec(t_bissec) = abs(b_bis_vec(t_bissec) - a_bis_vec(t_bissec));
end

//Exibe os resultados da Bissecção
printf('Iteracao\t a\t\t xm\t\t b\t\t f(a)\t\t f(xm)\t\t f(b)\t\t Erro\n');
for i = 1:t_bissec-1
    printf('%d\t\t %f\t %f\t %f\t %f\t %f\t %f\t %e\n', i, a_bis_vec(i), xm(i), b_bis_vec(i), fa_bis(i), fxm(i), fb_bis(i), erro_bissec(i));
end
