export type OrderPayload = {
  order_no?: string;
  product_id: number;
  quantity: number;
  full_name: string;
  phone1: string;
  phone2?: string;
  city?: string;
  area?: string;
  address_text: string;
  notes?: string;
  payment_method?: string;
};
