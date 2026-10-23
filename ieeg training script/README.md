# iEEG Training Script

This folder contains the training pipeline for the spiking neural network (SNN) used for neural decoding: a regression of 2D cursor velocity from intracortical neural recordings.

## Contents

- **`ieeg_training_script.ipynb`** — training notebook, written for Google Colab. It builds and trains a 3-layer feedforward SNN (64-128-64 LIF neurons, leaky-integrator readout) with [snnTorch](https://github.com/jeshraghian/snntorch). The script supports input channel selection based on I/O correlation-based relevance. The trained model is evaluated with R², correlation coefficient, MAE, [NeuroBench](https://github.com/NeuroBench/neurobench) metrics, and average end-point error on the reconstructed cursor position.
- **`indy_20170123_02_1ms_thr5_mean_abs_window8192.mat`** — preprocessed dataset used for training (record `indy_20170123_02`, binned at 1 ms).

## Dataset

The data comes from the **O'Doherty / Sabes lab** dataset *"Nonhuman Primate Reaching with Multichannel Sensorimotor Cortex Electrophysiology"*, publicly available on Zenodo:

👉 **https://zenodo.org/records/3854034**

The preprocessed `.mat` file needed for training is included in this folder. The raw record (`indy_20170123_02.mat`) is only needed for the final position-estimation evaluation and is downloaded automatically by the notebook via `wget` from the Zenodo link above.

## Usage

1. Open the notebook in Google Colab.
2. Upload the preprocessed `.mat` file to the Colab session (or your Drive) and set `dataset_path` accordingly.
3. Optionally adjust the training configuration in the `train_setting` dictionary (target variable, learning rate, epochs, network size, neuron parameters).
4. Run all cells. The best model (lowest validation loss) is saved as `network_best` in the folder set by `trained_folder`, together with the training parameters and the loss curves.

## Requirements

The notebook installs its own dependencies (`snntorch`, `neurobench`); it also relies on PyTorch, NumPy, SciPy, Matplotlib and h5py, all preinstalled on Colab.

## Reference

This training pipeline was used in the following publication. If you use this code, please cite:

> G. Leone, L. Martis, L. Raffo and P. Meloni, *"Enabling SNN-Based Near-MEA Neural Decoding with Channel Selection: An Open-HW Approach,"* 2025 Design, Automation & Test in Europe Conference (DATE), 2025, pp. 1-7, doi: [10.23919/DATE64628.2025.10993220](https://doi.org/10.23919/DATE64628.2025.10993220).

```bibtex
@INPROCEEDINGS{10993220,
  author={Leone, Gianluca and Martis, Luca and Raffo, Luigi and Meloni, Paolo},
  booktitle={2025 Design, Automation \& Test in Europe Conference (DATE)},
  title={Enabling SNN-Based Near-MEA Neural Decoding with Channel Selection: An Open-HW Approach},
  year={2025},
  pages={1-7},
  doi={10.23919/DATE64628.2025.10993220}}
```
