// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VSubClauseEvaluator__Syms.h"


//======================

void VSubClauseEvaluator::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void VSubClauseEvaluator::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    VSubClauseEvaluator::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void VSubClauseEvaluator::traceInitTop(void* userp, VerilatedVcd* tracep) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void VSubClauseEvaluator::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBus(c+10,"clause_mask", false,-1, 4,0);
        tracep->declBus(c+11,"unassign", false,-1, 4,0);
        tracep->declBus(c+12,"assignment", false,-1, 4,0);
        tracep->declBus(c+13,"clause_pole", false,-1, 4,0);
        tracep->declBus(c+14,"var1", false,-1, 8,0);
        tracep->declBus(c+15,"var2", false,-1, 8,0);
        tracep->declBus(c+16,"var3", false,-1, 8,0);
        tracep->declBus(c+17,"var4", false,-1, 8,0);
        tracep->declBus(c+18,"var5", false,-1, 8,0);
        tracep->declBit(c+19,"unit_clause", false,-1);
        tracep->declBus(c+20,"implied_variable", false,-1, 8,0);
        tracep->declBit(c+21,"new_assignment", false,-1);
        tracep->declBus(c+10,"SubClauseEvaluator clause_mask", false,-1, 4,0);
        tracep->declBus(c+11,"SubClauseEvaluator unassign", false,-1, 4,0);
        tracep->declBus(c+12,"SubClauseEvaluator assignment", false,-1, 4,0);
        tracep->declBus(c+13,"SubClauseEvaluator clause_pole", false,-1, 4,0);
        tracep->declBus(c+14,"SubClauseEvaluator var1", false,-1, 8,0);
        tracep->declBus(c+15,"SubClauseEvaluator var2", false,-1, 8,0);
        tracep->declBus(c+16,"SubClauseEvaluator var3", false,-1, 8,0);
        tracep->declBus(c+17,"SubClauseEvaluator var4", false,-1, 8,0);
        tracep->declBus(c+18,"SubClauseEvaluator var5", false,-1, 8,0);
        tracep->declBit(c+19,"SubClauseEvaluator unit_clause", false,-1);
        tracep->declBus(c+20,"SubClauseEvaluator implied_variable", false,-1, 8,0);
        tracep->declBit(c+21,"SubClauseEvaluator new_assignment", false,-1);
        tracep->declBit(c+1,"SubClauseEvaluator partial_sat", false,-1);
        {int i; for (i=0; i<5; i++) {
                tracep->declBus(c+2+i*1,"SubClauseEvaluator var_indices", true,(i+0), 8,0);}}
        tracep->declBit(c+7,"SubClauseEvaluator unit_clause_pre", false,-1);
        tracep->declBus(c+8,"SubClauseEvaluator encoded_position", false,-1, 2,0);
        tracep->declBit(c+22,"SubClauseEvaluator new_assignment_pre", false,-1);
        tracep->declBus(c+10,"SubClauseEvaluator partial_sat_eval clause_mask", false,-1, 4,0);
        tracep->declBus(c+11,"SubClauseEvaluator partial_sat_eval unassign", false,-1, 4,0);
        tracep->declBus(c+12,"SubClauseEvaluator partial_sat_eval assignment", false,-1, 4,0);
        tracep->declBus(c+13,"SubClauseEvaluator partial_sat_eval clause_pole", false,-1, 4,0);
        tracep->declBit(c+1,"SubClauseEvaluator partial_sat_eval partial_sat", false,-1);
        tracep->declBus(c+10,"SubClauseEvaluator partial_sat_eval valid_vars", false,-1, 4,0);
        tracep->declBus(c+23,"SubClauseEvaluator partial_sat_eval assigned_vars", false,-1, 4,0);
        tracep->declBus(c+24,"SubClauseEvaluator partial_sat_eval satisfied_vals", false,-1, 4,0);
        tracep->declBus(c+9,"SubClauseEvaluator partial_sat_eval eval_result", false,-1, 4,0);
        tracep->declBus(c+10,"SubClauseEvaluator unit_clause_eval clause_mask", false,-1, 4,0);
        tracep->declBus(c+11,"SubClauseEvaluator unit_clause_eval unassign", false,-1, 4,0);
        tracep->declBus(c+13,"SubClauseEvaluator unit_clause_eval clause_pole", false,-1, 4,0);
        tracep->declBus(c+8,"SubClauseEvaluator unit_clause_eval implied_variable", false,-1, 2,0);
        tracep->declBit(c+22,"SubClauseEvaluator unit_clause_eval new_assignment", false,-1);
        tracep->declBit(c+7,"SubClauseEvaluator unit_clause_eval unit_clause", false,-1);
        tracep->declBus(c+25,"SubClauseEvaluator unit_clause_eval valid_unassigned", false,-1, 4,0);
        tracep->declBus(c+8,"SubClauseEvaluator unit_clause_eval encoded_position", false,-1, 2,0);
        tracep->declBit(c+7,"SubClauseEvaluator unit_clause_eval valid_unit", false,-1);
    }
}

void VSubClauseEvaluator::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void VSubClauseEvaluator::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void VSubClauseEvaluator::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullBit(oldp+1,((0U != (IData)(vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result))));
        tracep->fullSData(oldp+2,(vlTOPp->SubClauseEvaluator__DOT__var_indices[0]),9);
        tracep->fullSData(oldp+3,(vlTOPp->SubClauseEvaluator__DOT__var_indices[1]),9);
        tracep->fullSData(oldp+4,(vlTOPp->SubClauseEvaluator__DOT__var_indices[2]),9);
        tracep->fullSData(oldp+5,(vlTOPp->SubClauseEvaluator__DOT__var_indices[3]),9);
        tracep->fullSData(oldp+6,(vlTOPp->SubClauseEvaluator__DOT__var_indices[4]),9);
        tracep->fullBit(oldp+7,(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit));
        tracep->fullCData(oldp+8,(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position),3);
        tracep->fullCData(oldp+9,(vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result),5);
        tracep->fullCData(oldp+10,(vlTOPp->clause_mask),5);
        tracep->fullCData(oldp+11,(vlTOPp->unassign),5);
        tracep->fullCData(oldp+12,(vlTOPp->assignment),5);
        tracep->fullCData(oldp+13,(vlTOPp->clause_pole),5);
        tracep->fullSData(oldp+14,(vlTOPp->var1),9);
        tracep->fullSData(oldp+15,(vlTOPp->var2),9);
        tracep->fullSData(oldp+16,(vlTOPp->var3),9);
        tracep->fullSData(oldp+17,(vlTOPp->var4),9);
        tracep->fullSData(oldp+18,(vlTOPp->var5),9);
        tracep->fullBit(oldp+19,(vlTOPp->unit_clause));
        tracep->fullSData(oldp+20,(vlTOPp->implied_variable),9);
        tracep->fullBit(oldp+21,(vlTOPp->new_assignment));
        tracep->fullBit(oldp+22,((1U & (~ ((4U >= (IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position)) 
                                           & ((IData)(vlTOPp->clause_pole) 
                                              >> (IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position)))))));
        tracep->fullCData(oldp+23,((0x1fU & (~ (IData)(vlTOPp->unassign)))),5);
        tracep->fullCData(oldp+24,(((IData)(vlTOPp->assignment) 
                                    ^ (IData)(vlTOPp->clause_pole))),5);
        tracep->fullCData(oldp+25,(((IData)(vlTOPp->clause_mask) 
                                    & (IData)(vlTOPp->unassign))),5);
    }
}
