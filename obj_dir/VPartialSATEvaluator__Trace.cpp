// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VPartialSATEvaluator__Syms.h"


void VPartialSATEvaluator::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void VPartialSATEvaluator::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->chgCData(oldp+0,(vlTOPp->clause_mask),5);
        tracep->chgCData(oldp+1,(vlTOPp->unassign),5);
        tracep->chgCData(oldp+2,(vlTOPp->assignment),5);
        tracep->chgCData(oldp+3,(vlTOPp->clause_pole),5);
        tracep->chgBit(oldp+4,(vlTOPp->partial_sat));
        tracep->chgCData(oldp+5,((0x1fU & (~ (IData)(vlTOPp->unassign)))),5);
        tracep->chgCData(oldp+6,(((IData)(vlTOPp->assignment) 
                                  ^ (IData)(vlTOPp->clause_pole))),5);
        tracep->chgCData(oldp+7,((((IData)(vlTOPp->clause_mask) 
                                   & (~ (IData)(vlTOPp->unassign))) 
                                  & ((IData)(vlTOPp->assignment) 
                                     ^ (IData)(vlTOPp->clause_pole)))),5);
    }
}

void VPartialSATEvaluator::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
    }
}
