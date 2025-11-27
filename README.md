# **Amazon Robotics Fulfillment Simulator**

A scalable simulation framework that models multi-robot warehouse fulfillment workflows—built to generate high-volume operational data for analytics, forecasting, and ML experimentation.

## **Overview**

This project simulates a coordinated fleet of warehouse robots transporting packages across a fulfillment center. It combines **discrete-event simulation**, **containerized execution**, and **AWS cloud-native data infrastructure** to generate large, realistic datasets for downstream analysis.

The system runs as:

* A **Python + SimPy robotic fulfillment simulator**
* Containerized in **Docker**
* Scaled via **Terraform-provisioned Amazon EKS**
* Streaming results through **Kinesis → Firehose → S3** for persistent analytics

This work was presented at the **University of Washington’s CSEED Fellowship**, where it received an **Award for Technical Growth** for engineering depth and applied cloud architecture.

---

## **✨ Key Features**

### 🚧 **High-Fidelity Robotic Simulation**

* Simulates **multiple robots** navigating fulfillment tasks.
* Configurable environment:

  * Duration
  * Number of robots
  * Number of packages
  * Routing and task queues
* Reproducible SimPy event-driven architecture.

### 🐳 **Containerized and Cloud-Ready**

* Fully dockerized simulation engine.
* Terraform modules provision:

  * Amazon EKS cluster
  * Node groups
  * IAM roles for service access
  * Kinesis streams + Firehose pipeline
  * S3 analytics bucket

### ⚡ **Distributed Parallel Simulation**

* Launch **dozens to hundreds** of concurrent simulation pods.
* Parallel runs multiply data-generation throughput—ideal for:

  * ML training datasets
  * Agent-based modeling
  * Stress-testing robotics workflows
  * Throughput and latency studies

### 📡 **Real-Time Data Pipeline**

* Simulation events streamed via **Amazon Kinesis**.
* Data automatically **buffered, compressed, and delivered** by Firehose.
* Stored in Amazon S3 in analytics-friendly layouts.

---

## **📁 Project Structure**

```
.
├── simulator/
│   ├── robots.py          # Robot behavior + routing logic
│   ├── env.py             # SimPy environment orchestration
│   ├── run.py             # Entrypoint for single simulation execution
│   └── config.yaml        # Adjustable sim parameters
│
├── infra/
│   ├── main.tf            # EKS, Kinesis, Firehose, IAM
│   ├── variables.tf       
│   ├── eks/               # Modularized Kubernetes cluster creation
│   └── kinesis/           
│
├── docker/
│   └── Dockerfile         # Container for the simulator
│
└── k8s/
    ├── job.yaml           # Defines parallel simulation jobs
    └── configmap.yaml
```

---

## **🧠 Why I Built This**

Modern fulfillment centers rely on high-throughput robotics systems. But obtaining **large, labeled, repeatable** datasets for modeling those systems is hard.

This project solves that by:

* Creating a **controllable digital twin** for experimentation
* Scaling simulation runs across cloud infrastructure
* Capturing data that mirrors real operational semantics

It’s meant to support:

* ML feature engineering
* Time-series forecasting
* Optimization research
* Human-robot workflow analysis
* Stress testing and benchmarking

---

## **🚀 Getting Started**

### **1. Deploy Cloud Infrastructure**

```bash
terraform init
terraform apply
```

### **2. Launch Parallel Sims**

```bash
kubectl apply -f k8s/job.yaml
```

---

## **📊 Example Output**

Simulations generate event logs such as:

* Robot pickup & drop events
* Travel times & distances
* Queue wait times
* Collision-avoidance delays
* Package throughput per time unit

Delivered to S3 in compressed Firehose parquet batches.

---

## **🏆 Recognition**

This project was presented at the **UW CSEED Fellowship**, a selective engineering fellowship.
It received an **Award for Technical Growth** for demonstrating strong architectural design, AWS proficiency, and simulation engineering.

---

## **🛠️ Tech Stack**

**Simulation:** Python, SimPy
**Infrastructure:** Terraform, AWS EKS, IAM, VPC
**Data Pipeline:** Kinesis Streams, Firehose, Amazon S3
**Containerization:** Docker
**Orchestration:** Kubernetes Jobs

---
