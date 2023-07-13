import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/services/files_display_prefs.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FileContents extends StatefulWidget {
  final String title;
  final IconData iconData;
  List<CLoudVaultFile>? cloudVaultFiles;

  FileContents({
    required this.title,
    required this.iconData,
    this.cloudVaultFiles,
    super.key,
  });

  @override
  State<FileContents> createState() => _FileContentsState();
}

class _FileContentsState extends State<FileContents> {
  bool? isGrid;

  @override
  void initState() {
    isGrid = FileDisplayPreference.isGrid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filesProvider = Provider.of<FileProvider>(context);
    return filesProvider.isLoading
        ? const LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isGrid = !isGrid!;
                      });
                      FileDisplayPreference.toggle(isGrid!);
                    },
                    child: Icon(
                      isGrid! ? Icons.list : Icons.grid_view,
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: filesProvider.isLoading
                  ? const LoadingWidget()
                  : isGrid!
                      ? GridView.builder(
                          itemCount: widget.cloudVaultFiles!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            final cloudVaultFile =
                                widget.cloudVaultFiles![index];
                            return GridFile(cloudVaultFile: cloudVaultFile);
                          },
                        )
                      : ListView.builder(
                          itemCount: widget.cloudVaultFiles!.length,
                          itemBuilder: (context, index) {
                            final cloudVaultFile =
                                widget.cloudVaultFiles![index];
                            return ListTile(
                              leading: SizedBox(
                                  width: 12.w,
                                  child: Image.network(cloudVaultFile.url!)),
                              title: Text(
                                cloudVaultFile.file!.name,
                                style: kTextStyle(context: context, size: 12),
                              ),
                            );
                          },
                        ),
            ),
          );
  }
}

class GridFile extends StatelessWidget {
  final CLoudVaultFile cloudVaultFile;

  const GridFile({
    super.key,
    required this.cloudVaultFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 0.3,
          ),
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 0.3,
          )
        ],
      ),
      child: Column(
        children: [
          Expanded(child: Image.network(cloudVaultFile.url!)),
          Text(
            cloudVaultFile.file!.name,
            style: kTextStyle(context: context, size: 10),
          ),
        ],
      ),
    );
  }
}
