// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VPartialSATEvaluator__Syms.h"


//======================

void VPartialSATEvaluator::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void VPartialSATEvaluator::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    VPartialSATEvaluator::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void VPartialSATEvaluator::traceInitTop(void* userp, VerilatedVcd* tracep) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void VPartialSATEvaluator::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBus(c+1,"clause_mask", false,-1, 4,0);
        tracep->declBus(c+2,"unassign", false,-1, 4,0);
        tracep->declBus(c+3,"assignment", false,-1, 4,0);
        tracep->declBus(c+4,"clause_pole", false,-1, 4,0);
        tracep->declBit(c+5,"partial_sat", false,-1);
        tracep->declBus(c+1,"PartialSATEvaluator clause_mask", false,-1, 4,0);
        tracep->declBus(c+2,"PartialSATEvaluator unassign", false,-1, 4,0);
        tracep->declBus(c+3,"PartialSATEvaluator assignment", false,-1, 4,0);
        tracep->declBus(c+4,"PartialSATEvaluator clause_pole", false,-1, 4,0);
        tracep->declBit(c+5,"PartialSATEvaluator partial_sat", false,-1);
        tracep->declBus(c+1,"PartialSATEvaluator valid_vars", false,-1, 4,0);
        tracep->declBus(c+6,"PartialSATEvaluator assigned_vars", false,-1, 4,0);
        tracep->declBus(c+7,"PartialSATEvaluator satisfied_vals", false,-1, 4,0);
        tracep->declBus(c+8,"PartialSATEvaluator eval_result", false,-1, 4,0);
    }
}

void VPartialSATEvaluator::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void VPartialSATEvaluator::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void VPartialSATEvaluator::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    VPartialSATEvaluator__Syms* __restrict vlSymsp = static_cast<VPartialSATEvaluator__Syms*>(userp);
    VPartialSATEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullCData(oldp+1,(vlTOPp->clause_mask),5);
        tracep->fullCData(oldp+2,(vlTOPp->unassign),5);
        tracep->fullCData(oldp+3,(vlTOPp->assignment),5);
        tracep->fullCData(oldp+4,(vlTOPp->clause_pole),5);
        tracep->fullBit(oldp+5,(vlTOPp->partial_sat));
        tracep->fullCData(oldp+6,((0x1fU & (~ (IData)(vlTOPp->unassign)))),5);
        tracep->fullCData(oldp+7,(((IData)(vlTOPp->assignment) 
                                   ^ (IData)(vlTOPp->clause_pole))),5);
        tracep->fullCData(oldp+8,((((IData)(vlTOPp->clause_mask) 
                                    & (~ (IData)(vlTOPp->unassign))) 
                                   & ((IData)(vlTOPp->assignment) 
                                      ^ (IData)(vlTOPp->clause_pole)))),5);
    }
}
