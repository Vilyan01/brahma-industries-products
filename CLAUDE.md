# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains 3D printing product designs built with OpenSCAD. Designs are authored as `.scad` files and exported as `.stl` files for printing.

## Repository Structure

Each product lives in its own top-level directory (e.g., `magwell/`). Product directories contain OpenSCAD source files and any exported STL artifacts.

## Working with OpenSCAD

- Source files use the `.scad` extension
- OpenSCAD uses a functional, declarative syntax for constructive solid geometry (CSG)
- To preview/render designs locally: `openscad <file.scad>`
- To export STL from command line: `openscad -o output.stl input.scad`
- Units in OpenSCAD are typically millimeters
