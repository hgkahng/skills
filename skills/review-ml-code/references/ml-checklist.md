# ML Code Review Checklist

Apply selectively based on what the code does.

## Training Loop (PyTorch)

- [ ] optimizer.zero_grad() called before backward (or set_to_none=True for efficiency)
- [ ] Gradient clipping applied after backward, before step
- [ ] With AMP, scaler.unscale_(optimizer) called before clip_grad_norm_ (clipping scaled grads against an unscaled max-norm is a silent bug)
- [ ] LR scheduler.step() placement correct (per-batch vs per-epoch)
- [ ] Mixed precision: scaler.scale(loss).backward(), scaler.step(), scaler.update() sequence
- [ ] model.train() / model.eval() mode set correctly
- [ ] torch.no_grad() or torch.inference_mode() used during evaluation
- [ ] .detach() used where gradients shouldn't flow

## Reproducibility

- [ ] Random seeds set (random, numpy, torch, torch.cuda)
- [ ] torch.backends.cudnn.deterministic = True if strict reproducibility needed
- [ ] DataLoader worker_init_fn seeds workers properly
- [ ] Shuffle disabled for validation/test loaders

## Data Pipeline

- [ ] No data leakage between train/val/test splits
- [ ] Augmentation applied only to training data
- [ ] drop_last=True if batch norm used with small final batches
- [ ] num_workers > 0 for performance (but 0 for debugging)
- [ ] pin_memory=True when using GPU

## Device Handling

- [ ] Tensors and model on same device
- [ ] .to(device) applied consistently
- [ ] New tensors created on correct device (not defaulting to CPU)

## Memory

- [ ] .item() used when logging scalar values (not tensor)
- [ ] Intermediate tensors detached or deleted if not needed
- [ ] torch.cuda.empty_cache() used sparingly and appropriately
- [ ] Gradient accumulation divides loss correctly

## Numerical Stability

- [ ] Epsilon added to denominators and log arguments
- [ ] Log-softmax used instead of log(softmax()) 
- [ ] Softmax computed with x - x.max() for stability
- [ ] Check for NaN/Inf in loss or gradients

## Checkpointing

- [ ] Save optimizer and scheduler state, not just model
- [ ] Save/load AMP scaler state when using mixed precision
- [ ] Resumption loads all saved state
- [ ] Checkpoint includes epoch/step for proper resumption

## Logging

- [ ] .item() used to avoid memory leak from tensor accumulation
- [ ] Logging frequency appropriate (not every step for large datasets)
- [ ] Metrics computed correctly (epoch-level vs batch-level averaging)

## Numpy

- [ ] Avoid implicit copies with advanced indexing when not needed
- [ ] Use out= parameter for in-place operations where appropriate
- [ ] Broadcasting used instead of explicit loops
- [ ] Dtype specified to avoid float64 default when float32 suffices

## Pandas

- [ ] .copy() used when modification shouldn't affect original
- [ ] Avoid chained indexing (use .loc/.iloc)
- [ ] Categorical dtype for low-cardinality string columns
- [ ] Vectorized operations instead of iterrows/apply where possible

## Scikit-learn

- [ ] Fit on train data only, transform on train/val/test
- [ ] Pipeline used to prevent leakage in cross-validation
- [ ] random_state set for reproducibility
- [ ] Feature scaling applied appropriately

## Plotting

- [ ] Figure closed after saving (plt.close())
- [ ] DPI and figsize set for intended output
- [ ] Colorbar/legend included where needed
- [ ] Axis labels and titles present
