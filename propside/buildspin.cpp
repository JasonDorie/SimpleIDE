/*
 * This file is part of the Parallax Propeller SimpleIDE development environment.
 *
 * Copyright (C) 2014 Parallax Incorporated
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "buildspin.h"
#include "Sleeper.h"

#include "properties.h"
#include "asideconfig.h"

BuildSpin::BuildSpin(ProjectOptions *projopts, QPlainTextEdit *compstat, QLabel *stat, QLabel *progsize, QProgressBar *progbar, QComboBox *cb, Properties *p)
    : Build(projopts, compstat, stat, progsize, progbar, cb, p)
{
}

int  BuildSpin::runBuild(QString option, QString projfile, QString compiler)
{
    int rc = -1;

    projectFile = projfile;
    aSideCompiler = compiler;
    aSideCompilerPath = sourcePath(compiler);

    QFile file(projfile);
    if(file.exists() == false)
        return rc;
    char buffer[80];
    if(file.open(QFile::ReadOnly)) {
        file.readLine(buffer,80);
        file.close();
    }
    QString spinfile(buffer);

    spinfile = spinfile.trimmed();

    progress->show();
    programSize->setText("");

    compileStatus->setPlainText(tr("Project Directory: ")+sourcePath(projectFile)+"\r\n");
    compileStatus->moveCursor(QTextCursor::End);
    status->setText(tr("Building ...")+" "+spinfile);

    rc = runBstc(spinfile);
    status->setText(status->text()+" done.");
    if(rc) statusFailed();
    return rc;
}

int  BuildSpin::makeDebugFiles(QString fileName, QString projfile, QString compiler)
{
    projectFile = projfile;
    aSideCompiler = compiler;
    aSideCompilerPath = sourcePath(compiler);

    return 0;
}


int  BuildSpin::runBstc(QString spinfile)
{
    int rc = 0;

    //getApplicationSettings();
    if(checkCompilerInfo()) {
        return -1;
    }

    QStringList args;

    /* run the bstc program */
    QString spin = properties->getSpinCompilerStr();
    QString comp = spin.mid(spin.lastIndexOf("/")+1);

    QDir libdir;

    if((comp.compare("spin",Qt::CaseInsensitive) == 0) ||
       (comp.compare("spin.exe",Qt::CaseInsensitive) == 0) ||
       (comp.compare("openspin",Qt::CaseInsensitive) == 0) ||
       (comp.compare("openspin.exe",Qt::CaseInsensitive) == 0)) {
        // Roy's compiler always makes a .binary
        if(libdir.exists(properties->getSpinLibraryStr())) {
            args.append("-I");
            args.append(properties->getSpinLibraryStr());
        }
    }
    else {
        /* other compiler options */
        if(projectOptions->getSpinCompOptions().length()) {
            QStringList complist = projectOptions->getSpinCompOptions().split(" ",QString::SkipEmptyParts);
            foreach(QString compopt, complist) {
                args.append(compopt);
            }
        }

        // BSTC needs to be told to make a .binary
        args.append("-b");
        if(libdir.exists(properties->getSpinLibraryStr())) {
            args.append("-L");
            args.append(properties->getSpinLibraryStr());
        }
    }

    args.append(spinfile); // using shortname limits us to files in the project directory.

    rc = startProgram(spin, sourcePath(projectFile), args);

    /*
     * Report program size
     * Use the projectFile instead of the current tab file
     */
    QString ssize;
    if(codeSize != 0)
        ssize = QString(tr("Code Size")+" %L1 "+tr("bytes")).arg(codeSize);
    programSize->setText(ssize);
    progress->setVisible(false);
    return rc;
}

void BuildSpin::appendLoaderParameters(QString copts, QString projfile, QStringList *args)
{
    QString filename = projfile.mid(0,projectFile.lastIndexOf("."));
    args->append(copts);
    args->append(filename+".binary");

    qDebug() << args;
}
