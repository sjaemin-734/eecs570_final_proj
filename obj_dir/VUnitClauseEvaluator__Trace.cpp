// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VUnitClauseEvaluator__Syms.h"


void VUnitClauseEvaluator::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void VUnitClauseEvaluator::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->chgCData(oldp+0,(vlTOPp->clause_mask),5);
        tracep->chgCData(oldp+1,(vlTOPp->unassign),5);
        tracep->chgCData(oldp+2,(vlTOPp->clause_pole),5);
        tracep->chgCData(oldp+3,(vlTOPp->implied_variable),3);
        tracep->chgBit(oldp+4,(vlTOPp->new_assignment));
        tracep->chgBit(oldp+5,(vlTOPp->unit_clause));
        tracep->chgCData(oldp+6,(((IData)(vlTOPp->clause_mask) 
                                  & (IData)(vlTOPp->unassign))),5);
        tracep->chgCData(oldp+7,(vlTOPp->UnitClauseEvaluator__DOT__encoded_position),3);
        tracep->chgBit(oldp+8,(vlTOPp->UnitClauseEvaluator__DOT__valid_unit));
    }
}

void VUnitClauseEvaluator::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    VUnitClauseEvaluator__Syms* __restrict vlSymsp = static_cast<VUnitClauseEvaluator__Syms*>(userp);
    VUnitClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
    }
}
