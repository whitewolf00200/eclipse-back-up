public class NextVisitUtils {
    public static integer mtoi(string m){
        integer im = 1;
        if(m=='JAN')im=1;
        if(m=='FEB')im=2;
        if(m=='MAR')im=3;
        if(m=='APR')im=4;
        if(m=='MAY')im=5;
        if(m=='JUN')im=6;
        if(m=='JUL')im=7;
        if(m=='AUG')im=8;
        if(m=='SEP')im=9;
        if(m=='OCT')im=10;
        if(m=='NOV')im=11;
        if(m=='DEC')im=12;
        if(m=='1' || m=='01')im=1;
        if(m=='2' || m=='02')im=2;
        if(m=='3' || m=='03')im=3;
        if(m=='4' || m=='04')im=4;
        if(m=='5' || m=='05')im=5;
        if(m=='6' || m=='06')im=6;
        if(m=='7' || m=='07')im=7;
        if(m=='8' || m=='08')im=8;
        if(m=='9' || m=='09')im=9;
        if(m=='10' || m=='10')im=10;
        if(m=='11' || m=='11')im=11;
        if(m=='12' || m=='12')im=12;
        return im;
    }
    
    @isTest
    public static void NextVisitUtils_test(){
        mtoi('FEB');
    }
}