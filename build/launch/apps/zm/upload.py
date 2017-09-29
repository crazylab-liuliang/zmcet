import os
import oss2

access_key_id = "LTAIn09uY98LyNVH"
access_key_secret = "U0FSBe9oFiaha98iRTVEPdZywQaFuC"
bucket_name = "albertlab-huanan"
endpoint = "oss-cn-shenzhen.aliyuncs.com"

bucket = oss2.Bucket(oss2.Auth(access_key_id, access_key_secret), endpoint, bucket_name)

# generate version meta
os.system("python gen_version_meta.py")

# upload
oss2.resumable_upload(bucket, "Software/zm/update/version.meta", "version.meta", multipart_threshold=100*1024)
print("upload file [version.meta] to ALIYUN oss")

# upload pcks
root_path = os.getcwd() + '/'
dirs = os.listdir(root_path)
dirs.sort()
for file in dirs:
    if os.path.splitext(file)[1] == '.pck':
        oss2.resumable_upload(bucket, "Software/zm/update/" + file, file, multipart_threshold=100*1024)
        print("upload file [%s] to ALIYUN oss" % file)
        print("upload files finished")