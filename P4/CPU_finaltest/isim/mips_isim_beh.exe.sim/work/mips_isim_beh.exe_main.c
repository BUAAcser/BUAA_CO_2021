/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000001929141814_3224323566_init();
    work_m_00000000003635382857_4144471541_init();
    work_m_00000000003183978651_0757879789_init();
    work_m_00000000004128526666_0609924071_init();
    work_m_00000000002757070856_3971628183_init();
    work_m_00000000002280314689_1621229167_init();
    work_m_00000000002389683584_2155959017_init();
    work_m_00000000002159601923_0886308060_init();
    work_m_00000000003903128812_2924402094_init();
    work_m_00000000000585693690_3877310806_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000000585693690_3877310806");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}