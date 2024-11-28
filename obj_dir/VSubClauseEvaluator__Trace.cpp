// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VSubClauseEvaluator__Syms.h"


void VSubClauseEvaluator::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void VSubClauseEvaluator::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgBit(oldp+0,((0U != (IData)(vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result))));
            tracep->chgSData(oldp+1,(vlTOPp->SubClauseEvaluator__DOT__var_indices[0]),9);
            tracep->chgSData(oldp+2,(vlTOPp->SubClauseEvaluator__DOT__var_indices[1]),9);
            tracep->chgSData(oldp+3,(vlTOPp->SubClauseEvaluator__DOT__var_indices[2]),9);
            tracep->chgSData(oldp+4,(vlTOPp->SubClauseEvaluator__DOT__var_indices[3]),9);
            tracep->chgSData(oldp+5,(vlTOPp->SubClauseEvaluator__DOT__var_indices[4]),9);
            tracep->chgBit(oldp+6,(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit));
            tracep->chgCData(oldp+7,(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position),3);
            tracep->chgCData(oldp+8,(vlTOPp->SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result),5);
        }
        tracep->chgCData(oldp+9,(vlTOPp->clause_mask),5);
        tracep->chgCData(oldp+10,(vlTOPp->unassign),5);
        tracep->chgCData(oldp+11,(vlTOPp->assignment),5);
        tracep->chgCData(oldp+12,(vlTOPp->clause_pole),5);
        tracep->chgSData(oldp+13,(vlTOPp->var1),9);
        tracep->chgSData(oldp+14,(vlTOPp->var2),9);
        tracep->chgSData(oldp+15,(vlTOPp->var3),9);
        tracep->chgSData(oldp+16,(vlTOPp->var4),9);
        tracep->chgSData(oldp+17,(vlTOPp->var5),9);
        tracep->chgBit(oldp+18,(vlTOPp->unit_clause));
        tracep->chgSData(oldp+19,(vlTOPp->implied_variable),9);
        tracep->chgBit(oldp+20,(vlTOPp->new_assignment));
        tracep->chgBit(oldp+21,((1U & (~ ((4U >= (IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position)) 
                                          & ((IData)(vlTOPp->clause_pole) 
                                             >> (IData)(vlTOPp->SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position)))))));
        tracep->chgCData(oldp+22,((0x1fU & (~ (IData)(vlTOPp->unassign)))),5);
        tracep->chgCData(oldp+23,(((IData)(vlTOPp->assignment) 
                                   ^ (IData)(vlTOPp->clause_pole))),5);
        tracep->chgCData(oldp+24,(((IData)(vlTOPp->clause_mask) 
                                   & (IData)(vlTOPp->unassign))),5);
    }
}

void VSubClauseEvaluator::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VSubClauseEvaluator__Syms*>(userp);
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
    }
}
