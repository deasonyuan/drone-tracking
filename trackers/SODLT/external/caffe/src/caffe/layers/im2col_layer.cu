// Copyright 2013 Yangqing Jia

#include <vector>

#include "caffe/layer.hpp"
#include "caffe/util/im2col.hpp"
#include "caffe/vision_layers.hpp"
#include "caffe/common.hpp"

namespace caffe {

template <typename Dtype>
void Im2colLayer<Dtype>::Forward_gpu(const vector<Blob<Dtype>*>& bottom,
      vector<Blob<Dtype>*>* top) {
  const Dtype* bottom_data = bottom[0]->gpu_data();
  Dtype* top_data = (*top)[0]->mutable_gpu_data();
  for (int n = 0; n < bottom[0]->num(); ++n) {
    im2col_gpu(bottom_data + bottom[0]->offset(n), CHANNELS_, HEIGHT_,
        WIDTH_, KSIZE_, PAD_, STRIDE_, top_data + (*top)[0]->offset(n), 0);
  }
}

template <typename Dtype>
Dtype Im2colLayer<Dtype>::Backward_gpu(const vector<Blob<Dtype>*>& top,
      const bool propagate_down, vector<Blob<Dtype>*>* bottom) {
  const Dtype* top_diff = top[0]->gpu_diff();
  Dtype* bottom_diff = (*bottom)[0]->mutable_gpu_diff();
  for (int n = 0; n < top[0]->num(); ++n) {
    col2im_gpu(top_diff + top[0]->offset(n), CHANNELS_, HEIGHT_,
        WIDTH_, KSIZE_, PAD_, STRIDE_, bottom_diff + (*bottom)[0]->offset(n), 0);
  }
  return Dtype(0.);
}


INSTANTIATE_CLASS(Im2colLayer);

}  // namespace caffe
