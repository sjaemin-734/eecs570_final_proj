// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VUNITCLAUSEEVALUATOR_H_
#define _VUNITCLAUSEEVALUATOR_H_  // guard

#include "verilated.h"

//==========

class VUnitClauseEvaluator__Syms;
class VUnitClauseEvaluator_VerilatedVcd;


//----------

VL_MODULE(VUnitClauseEvaluator) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(clause_mask,4,0);
    VL_IN8(unassign,4,0);
    VL_IN8(clause_pole,4,0);
    VL_OUT8(implied_variable,2,0);
    VL_OUT8(new_assignment,0,0);
    VL_OUT8(unit_clause,0,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    CData/*2:0*/ UnitClauseEvaluator__DOT__encoded_position;
    CData/*0:0*/ UnitClauseEvaluator__DOT__valid_unit;
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*4:0*/ __Vtableidx1;
    CData/*0:0*/ __Vm_traceActivity[1];
    static CData/*2:0*/ __Vtable1_UnitClauseEvaluator__DOT__encoded_position[32];
    static CData/*0:0*/ __Vtable1_UnitClauseEvaluator__DOT__valid_unit[32];
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    VUnitClauseEvaluator__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(VUnitClauseEvaluator);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    VUnitClauseEvaluator(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~VUnitClauseEvaluator();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(VUnitClauseEvaluator__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(VUnitClauseEvaluator__Syms* symsp, bool first);
  private:
    static QData _change_request(VUnitClauseEvaluator__Syms* __restrict vlSymsp);
    static QData _change_request_1(VUnitClauseEvaluator__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__1(VUnitClauseEvaluator__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(VUnitClauseEvaluator__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(VUnitClauseEvaluator__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(VUnitClauseEvaluator__Syms* __restrict vlSymsp) VL_ATTR_COLD;
  private:
    static void traceChgSub0(void* userp, VerilatedVcd* tracep);
    static void traceChgTop0(void* userp, VerilatedVcd* tracep);
    static void traceCleanup(void* userp, VerilatedVcd* /*unused*/);
    static void traceFullSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceFullTop0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitTop(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    void traceRegister(VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
