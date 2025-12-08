class data_file_def:
    def __init__(self, description: str, path: str, zip_path: str, is_national_file: bool = False):
        self.description = description
        self.path = path
        self.zip_path = zip_path
        self.is_national_file = is_national_file
        
def definitions() -> list[data_file_def]:
       
    definitions= [
                    data_file_def(
                    description="State Legislative Districts Lower Chamber (SLDL)",
                    path="SLDL",
                    zip_path="tl_2025_{}_sldl.zip",
                    
                ),
                    data_file_def(
                    description="Congressional Districts",
                    path="CD",
                    zip_path="tl_2025_{}_cd119.zip",
                ),
                    data_file_def(
                    description="State Legislative District - Upper Chamber (SLDU)",
                    path="SLDU",
                    zip_path="tl_2025_{}_sldu.zip",
                ),
                ]
    return definitions